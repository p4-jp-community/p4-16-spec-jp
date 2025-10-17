# P4‑16 Specification — 非公式日本語訳

> [!NOTE]
> 本リポジトリは、P4‑16公式仕様 **v1.2.5** を基に、Madokoの章分割・Markdown変換・MkDocs用体裁調整を行った **非公式（コミュニティ）** プロジェクトです。現時点では多くの章が英語のままで、クロスリファレンスも未解決です。正確な情報のためには公式仕様の確認を推奨します。
> - 上流（公式仕様）: [https://github.com/p4lang/p4-spec](https://github.com/p4lang/p4-spec)
> - 本プロジェクト: [https://github.com/p4-jp-community/p4-16-spec-jp](https://github.com/p4-jp-community/p4-16-spec-jp)
> - 法的情報: [NOTICE](docs/notice.md) / [LICENSE](docs/license.md)
> ---
> - **非公式**なコミュニティ活動であり、P4 Language Consortium とは関係がありません。

## リポジトリ構成 / Repository Structure

```
.
├─ docs/                 # 公開用 Markdown（章・付録）と静的アセット
│  ├─ index.md
│  ├─ chapters/
│  ├─ assets/figs/
│  └─ stylesheets/announce.css
├─ overrides/main.html   # MkDocs(Material) の announce バナー（JP/EN）
├─ upstream/             # 公式仕様のスナップショット（図版含む）
├─ mkdocs.yml            # サイト設定（Material テーマ）
├─ LICENSE.txt           # Apache License 2.0
├─ NOTICE.md             # 帰属・注意事項
└─ THIRD_PARTY_NOTICES.md
```

## 公開先 / Published Site
実際のWebページは以下のリンクからアクセスできます。

> https://p4-jp-community.github.io/p4-16-spec-jp/

## ライセンス / License

* **Apache License 2.0**（詳細は `LICENSE.txt` を参照）。
* 上流の帰属・注意事項については **`NOTICE.md`** およびサイト内の [NOTICE](docs/notice.md) を参照してください。
* 商標等は各権利者に帰属します。本プロジェクトは **非公式** です。

## 翻訳への参加 / Contributing to Translation
どなたからの貢献も歓迎いたします。翻訳や訳文の修正を行う場合は、このリポジトリをForkした後に`docs`ディレクトリ内の該当するMarkdownファイルを編集し、Pull Requestを作成してください。

不具合や改善提案については、Issueを作成してください。

---

## English (brief)

This repository hosts an **unofficial**, community‑maintained preparation for a Japanese translation of the **P4‑16 Language Specification v1.2.5**. The original Madoko is split per chapter, converted to Markdown, and formatted for the web with MkDocs. Many chapters remain in English and some cross‑references are unresolved.

* Upstream: [https://github.com/p4lang/p4-spec](https://github.com/p4lang/p4-spec)
* Project: [https://github.com/p4-jp-community/p4-16-spec-jp](https://github.com/p4-jp-community/p4-16-spec-jp)
* Legal: [NOTICE](docs/notice.md) / [LICENSE](docs/license.md)
