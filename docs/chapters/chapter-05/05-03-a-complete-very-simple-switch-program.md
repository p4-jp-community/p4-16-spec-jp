<a id="sec-vss-all"></a>
Here we provide a complete P4 program that implements basic forwarding
for IPv4 packets on the VSS architecture. This program does not utilize
all of the features provided by the architecture—e.g., recirculation—but
it does use preprocessor `#include` directives (see Section
[Preprocessing](../chapter-06/06-02-preprocessing.md#sec-preprocessor)).

<figure id="fig-vssmau">
  <img src="https://p4-jp-community.github.io/p4-16-spec-jp/assets/figs/vssmau.png" alt="Diagram of the match-action pipeline expressed by the VSS P4 program." style="width: 100%;">
  <figcaption>
  Diagram of the match-action pipeline expressed by the VSS P4 program.</figcaption>
</figure>

The parser attempts to recognize an Ethernet header
followed by an IPv4 header. If either of these headers are missing,
parsing terminates with an error. Otherwise it extracts the information
from these headers into a `Parsed_packet` structure. The match-action
pipeline is shown in Figure \[\#fig-vssmau\]; it comprises four
match-action units (represented by the P4 `table` keyword):

  - If any parser error has occurred, the packet is dropped (i.e., by
    assigning `outputPort` to `DROP_PORT`)
  - The first table uses the IPv4 destination address to determine the
    `outputPort` and the IPv4 address of the next hop. If this lookup
    fails, the packet is dropped. The table also decrements the IPv4
    `ttl` value.
  - The second table checks the `ttl` value: if the `ttl` becomes 0, the
    packet is sent to the control plane through the CPU port.
  - The third table uses the IPv4 address of the next hop (which was
    computed by the first table) to determine the Ethernet address of
    the next hop.
  - Finally, the last table uses the `outputPort` to identify the source
    Ethernet address of the current switch, which is set in the outgoing
    packet.

The deparser constructs the outgoing packet by reassembling the Ethernet
and IPv4 headers as computed by the pipeline.

```p4
// Include P4 core library
# include <core.p4>

// Include very simple switch architecture declarations
# include "very_simple_switch_model.p4"

// This program processes packets comprising an Ethernet and an IPv4
// header, and it forwards packets using the destination IP address

typedef bit<48>  EthernetAddress;
typedef bit<32>  IPv4Address;

// Standard Ethernet header
header Ethernet_h {
    EthernetAddress dstAddr;
    EthernetAddress srcAddr;
    bit<16>         etherType;
}

// IPv4 header (without options)
header IPv4_h {
    bit<4>       version;
    bit<4>       ihl;
    bit<8>       diffserv;
    bit<16>      totalLen;
    bit<16>      identification;
    bit<3>       flags;
    bit<13>      fragOffset;
    bit<8>       ttl;
    bit<8>       protocol;
    bit<16>      hdrChecksum;
    IPv4Address  srcAddr;
    IPv4Address  dstAddr;
}

// Structure of parsed headers
struct Parsed_packet {
    Ethernet_h ethernet;
    IPv4_h     ip;
}

// Parser section

// User-defined errors that may be signaled during parsing
error {
    IPv4OptionsNotSupported,
    IPv4IncorrectVersion,
    IPv4ChecksumError
}

parser TopParser(packet_in b, out Parsed_packet p) {
    Checksum16() ck;  // instantiate checksum unit

    state start {
        b.extract(p.ethernet);
        transition select(p.ethernet.etherType) {
            0x0800: parse_ipv4;
            // no default rule: all other packets rejected
        }
    }

    state parse_ipv4 {
        b.extract(p.ip);
        verify(p.ip.version == 4w4, error.IPv4IncorrectVersion);
        verify(p.ip.ihl == 4w5, error.IPv4OptionsNotSupported);
        ck.clear();
        ck.update(p.ip);
        // Verify that packet checksum is zero
        verify(ck.get() == 16w0, error.IPv4ChecksumError);
        transition accept;
    }
}

// Match-action pipeline section

control TopPipe(inout Parsed_packet headers,
                in error parseError, // parser error
                in InControl inCtrl, // input port
                out OutControl outCtrl) {
     IPv4Address nextHop;  // local variable

     /**
      * Indicates that a packet is dropped by setting the
      * output port to the DROP_PORT
      */
      action Drop_action() {
          outCtrl.outputPort = DROP_PORT;
      }

     /**
      * Set the next hop and the output port.
      * Decrements ipv4 ttl field.
      * @param ipv4_dest ipv4 address of next hop
      * @param port output port
      */
      action Set_nhop(IPv4Address ipv4_dest, PortId port) {
          nextHop = ipv4_dest;
          headers.ip.ttl = headers.ip.ttl - 1;
          outCtrl.outputPort = port;
      }

     /**
      * Computes address of next IPv4 hop and output port
      * based on the IPv4 destination of the current packet.
      * Decrements packet IPv4 TTL.
      * @param nextHop IPv4 address of next hop
      */
     table ipv4_match {
         key = { headers.ip.dstAddr: lpm; }  // longest-prefix match
         actions = {
              Drop_action;
              Set_nhop;
         }
         size = 1024;
         default_action = Drop_action;
     }

     /**
      * Send the packet to the CPU port
      */
      action Send_to_cpu() {
          outCtrl.outputPort = CPU_OUT_PORT;
      }

     /**
      * Check packet TTL and send to CPU if expired.
      */
     table check_ttl {
         key = { headers.ip.ttl: exact; }
         actions = { Send_to_cpu; NoAction; }
         const default_action = NoAction; // defined in core.p4
     }

     /**
      * Set the destination MAC address of the packet
      * @param dmac destination MAC address.
      */
      action Set_dmac(EthernetAddress dmac) {
          headers.ethernet.dstAddr = dmac;
      }

     /**
      * Set the destination Ethernet address of the packet
      * based on the next hop IP address.
      * @param nextHop IPv4 address of next hop.
      */
      table dmac {
          key = { nextHop: exact; }
          actions = {
               Drop_action;
               Set_dmac;
          }
          size = 1024;
          default_action = Drop_action;
      }

      /**
       * Set the source MAC address.
       * @param smac: source MAC address to use
       */
       action Set_smac(EthernetAddress smac) {
           headers.ethernet.srcAddr = smac;
       }

      /**
       * Set the source mac address based on the output port.
       */
      table smac {
           key = { outCtrl.outputPort: exact; }
           actions = {
                Drop_action;
                Set_smac;
          }
          size = 16;
          default_action = Drop_action;
      }

      apply {
          if (parseError != error.NoError) {
              Drop_action();  // invoke drop directly
              return;
          }

          ipv4_match.apply(); // Match result will go into nextHop
          if (outCtrl.outputPort == DROP_PORT) return;

          check_ttl.apply();
          if (outCtrl.outputPort == CPU_OUT_PORT) return;

          dmac.apply();
          if (outCtrl.outputPort == DROP_PORT) return;

          smac.apply();
    }
}

// deparser section
control TopDeparser(inout Parsed_packet p, packet_out b) {
    Checksum16() ck;
    apply {
        b.emit(p.ethernet);
        if (p.ip.isValid()) {
            ck.clear();              // prepare checksum unit
            p.ip.hdrChecksum = 16w0; // clear checksum
            ck.update(p.ip);         // compute new checksum.
            p.ip.hdrChecksum = ck.get();
        }
        b.emit(p.ip);
    }
}

// Instantiate the top-level VSS package
VSS(TopParser(),
    TopPipe(),
    TopDeparser()) main;
```
