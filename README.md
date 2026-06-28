# P4‑16 Specification — 非公式日本語訳

> [!NOTE]
> 本リポジトリは、P4‑16公式仕様 **v1.2.5** を基にした **非公式（コミュニティ）** の日本語訳プロジェクトです。現時点では多くの章が英語のままで、翻訳や体裁調整を継続しています。正確な情報のためには公式仕様の確認を推奨します。
> - 上流（公式仕様）: [https://github.com/p4lang/p4-spec](https://github.com/p4lang/p4-spec)
> - 本プロジェクト: [https://github.com/p4-jp-community/p4-16-spec-jp](https://github.com/p4-jp-community/p4-16-spec-jp)
> - 法的情報: [NOTICE](docs/notice.md) / [LICENSE](docs/license.md)
> ---
> - **非公式**なコミュニティ活動であり、P4 Language Consortium とは関係がありません。

## リポジトリ構成 / Repository Structure

```
.
├─ .github/              # GitHub Actions / リポジトリ設定
├─ docs/                 # 公開用 Markdown（章・付録）と静的アセット
│  ├─ index.md
│  ├─ chapters/
│  ├─ assets/figs/
│  ├─ notice.md
│  ├─ license.md
│  └─ stylesheets/announce.css
├─ overrides/main.html   # MkDocs(Material) の announce バナー（JP/EN）
├─ mkdocs.yml            # サイト設定（Material テーマ）
├─ pyproject.toml        # 開発ツール設定
├─ uv.lock               # 依存ロックファイル
├─ LICENSE.txt           # Apache License 2.0
├─ NOTICE.md             # 帰属・注意事項
├─ THIRD_PARTY_NOTICES.md
└─ site/                 # MkDocs ビルド生成物
```

## 公開先 / Published Site
実際のWebページは以下のリンクからアクセスできます。

> https://p4-jp-community.github.io/p4-16-spec-jp/

## ローカルでのビルドとプレビュー / Local Build and Preview

このリポジトリのサイトは MkDocs で生成します。ローカル確認には `uv` の利用を推奨します。

### 前提

- Python `3.13` 以上
- `uv`

### セットアップ

```bash
uv sync
```

### ビルド

```bash
uv run mkdocs build --strict
```

ビルド結果は `site/` に出力されます。

### ローカルプレビュー

```bash
uv run mkdocs serve
```

標準では `http://127.0.0.1:8000/p4-16-spec-jp/` で確認できます。

### `uv` を使わない場合

```bash
python -m venv .venv
. .venv/bin/activate
pip install mkdocs-material
python -m mkdocs build --strict
python -m mkdocs serve
```

## ライセンス / License

* **Apache License 2.0**（詳細は `LICENSE.txt` を参照）。
* 上流の帰属・注意事項については **`NOTICE.md`** およびサイト内の [NOTICE](docs/notice.md) を参照してください。
* 商標等は各権利者に帰属します。本プロジェクトは **非公式** です。

## 翻訳への参加 / Contributing to Translation
どなたからの貢献も歓迎いたします。翻訳や訳文の修正を行う場合は、このリポジトリをForkした後に`docs`ディレクトリ内の該当するMarkdownファイルを編集し、Pull Requestを作成してください。

不具合や改善提案については、Issueを作成してください。

---

## English (brief)

This repository hosts an **unofficial**, community‑maintained Japanese translation project for the **P4‑16 Language Specification v1.2.5**. The content is published as a MkDocs site, while many chapters remain in English and translation and formatting work are ongoing.

* Upstream: [https://github.com/p4lang/p4-spec](https://github.com/p4lang/p4-spec)
* Project: [https://github.com/p4-jp-community/p4-16-spec-jp](https://github.com/p4-jp-community/p4-16-spec-jp)
* Legal: [NOTICE](docs/notice.md) / [LICENSE](docs/license.md)
