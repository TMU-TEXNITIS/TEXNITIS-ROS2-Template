# TEXNITIS ROS 2 Template Repository

ROS 2ベースのプロジェクトで、ドキュメントや、自動ci/cdを簡単に使用するためのテンプレートリポジトリです。GitHub Actions、Docker、MkDocs のセットアップを同梱しており、リポジトリをテンプレート化して使い回すことを想定しています。
ROS 2開発をするなら卒業研究でも便利なものだと思うので、是非是非ご活用ください。

## 主な構成

- **Docker**: ROS 2 Jazzy 環境を含んだ開発コンテナ (`Dockerfile`) と GHCR への自動プッシュ用ワークフロー。
- **GitHub Actions**:
  - `ci-autofix.yaml`: clang-format の自動適用と `colcon build` によるビルドチェック。
  - `docker-build.yaml`: Docker イメージのビルドと GHCR へのプッシュ。
  - `mkdocs-deploy.yaml`: MkDocs によるドキュメントビルドと GitHub Pages へのデプロイ。
- **MkDocs**: Material テーマを用いたドキュメント雛形 (`mkdocs.yml` と `docs/`)。

## 使い方

1. GitHub 上でこのリポジトリをテンプレートとして新規リポジトリを作成する。
2. `README.md` や `docs/` 内のコンテンツをプロジェクトに合わせて編集する。
3. GitHub Actions で使用するシークレットを設定する（下記参照）。
4. 必要に応じて Dockerfile やワークフロー内の環境変数を調整する。

## 必要な GitHub シークレット

| 名前 | 用途 | 備考 |
| ---- | ---- | ---- |
| `PAT_TOKEN` | main ブランチへの自動コミット・プッシュ | `repo` スコープを付与した個人アクセストークンを推奨 |

> **メモ:** `PAT_TOKEN` を用意できない場合は、`ci-autofix.yaml` 内の `PAT_TOKEN` を `GITHUB_TOKEN` に置き換えて使用することも可能です（ただし、保護されたブランチ設定によっては動作しない場合があります）。
actionsのymlがあるせいでpushできないというエラーに遭遇した場合は、PATのclassicトークンの設定をいじるとActionsが使用できるようになるはずです。

## ローカルでのセットアップ

```bash
# 依存関係をインストールしつつビルド
colcon build --symlink-install

# セットアップスクリプトを読み込む
source install/setup.bash
```

Docker を利用する場合は、以下の手順でコンテナを起動できます。

```bash
# イメージをビルド
DOCKER_BUILDKIT=1 docker build -t texnitis-template:dev .

# コンテナを起動（必要に応じて volume を設定）
docker run --rm -it \
  --net=host \
  -v "$(pwd)":/workspaces/project \
  natto-template:dev \
  /bin/bash
```

## ディレクトリ構成

```
.
├── .github/workflows/   # CI/CD ワークフロー群
├── docs/                # MkDocs ドキュメント
├── src/                 # ROS 2 ワークスペース用のソースコード
├── Dockerfile           # 開発 & CI 用コンテナ
├── mkdocs.yml           # MkDocs 設定
└── README.md
```

## カスタマイズのヒント

- `Dockerfile` の `ARG TEXNITIS_TEMPLATE_REPO` を必要に応じてフォーク先や固定バージョンに変更する。
- `ci-autofix.yaml` の clang-format 対象やビルドコマンドをプロジェクトに合わせて変更。
- `mkdocs.yml` の `site_name` や `repo_url` を更新し、`docs/` 以下を整備。
- CI で使用するコンテナイメージ（`docker-build.yaml` → GHCR）を最初にビルド・プッシュしておくと `ci-autofix.yaml` がスムーズに動作します。

## ライセンス

テンプレート部分は MIT License を想定していますが、必要に応じて `LICENSE` ファイルを追加してください。
