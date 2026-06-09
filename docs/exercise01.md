# Exercise01: Microsoft Sentinel 利用環境の準備

#### ⏳ 推定時間: 20分

#### 💡 学習概要

後続のすべてのモジュールで使用される Microsoft Sentinel トレーニング ラボ ソリューションのデプロイについて説明します。

#### 🗒️ 目次

1. [Log Analytics Workspace 作成](#log-analytics-workspace-作成)
1. [Microsoft Sentinel ワークスペース 作成](#microsoft-sentinel-ワークスペース-作成)
1. [サンプルデータの投入](#サンプルデータの投入)
1. [Microsoft Sentinel プレイブックの構成](#microsoft-sentinel-プレイブックの構成)
1. [ロールの追加](#ロールの追加)
1. [Denfederポータル に ワークスペース を接続](#denfederポータル-に-ワークスペース-を接続)

## Log Analytics Workspace 作成

1. [Azure ポータル](https://portal.azure.com/) を開く
1. 上部の検索窓を使って `Log Analytics Workspace` を探して開く

    ![](../images/ex01/0001.png)

1. 左上「作成」を選択

    ![](../images/ex01/0002.png)

1. Log Analytics Workspace を開き、「作成」を選択
    1. 基本

        - リソースグループ: (任意の名前で新規作成)
        - 名前: (任意)
        - リージョン: (任意)
    
        ![](../images/ex01/0003.png)

    1. タグ

        デフォルトまま（設定なし）

    1. 確認と作成

        「作成」を選択

        ![](../images/ex01/0004.png)


## Microsoft Sentinel ワークスペース 作成

1. Azure ポータルを開き、上部検索窓から Sentinel を検索して開く

    ![](../images/ex01/0101.png)

1. 左上「作成」を選択

    ![](../images/ex01/0102.png)

1. 作成済のワークスペースを選択して「追加」

    ![](../images/ex01/0103.png)


## サンプルデータの投入

1. 以下のデプロイボタンより、サンプルデータを Log Analytics Workspace へ投入

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmsjpn-smecc-azure%2Fhandson-sentinel%2Fdevelop%2Fartifacts%2Fazuredeploy.json)

    (*) [ARMテンプレート](https://raw.githubusercontent.com/msjpn-smecc-azure/handson-sentinel/develop/artifacts/azuredeploy.json)

1. デプロイ画面で、以下の項目を入力して「確認と作成」を選択

    - サブスクリプション: (ハンズオン用に準備したもの)
    - リソースグループ: (作成した リソースグループ の名前)
    - リージョン: (作成した リソースグループ と同じリージョン)
    - ワークスペース: (作成した Log Analytics Workspace の名前)

    ![](../images/ex01/0201a.png)


<div style="text-align: center; font-size: 1.2em; font-weight: bold; margin: 4em;">
～ デプロイ待ち (20-30分) ☕☕☕ ... ～
</div>


1. (オプション) データ投入で利用した不要なリソース(`xxx` で始まる以下のリソース)を削除

    - Deployment Script
    - ストレージアカウント


## Microsoft Sentinel プレイブックの構成

1. デプロイされたリソースグループへ移動

    ![](../images/ex01-301.png)

1. リソース グループにある `azuresentinel-Get-GeoFromIpAndTagIncident` という API 接続リソースを選択

    ![](../images/ex01-302.png)

1. [全般]-[API接続の編集] を開く

    ![](../images/ex01-303.png)

1. 「承諾する」を開き、「承諾する」を選択

    ![](../images/ex01-304.png)

1. ログイン画面が表示されるので、作業用のご自身のアカウントでログイン

    ![](../images/ex01-305.png)

1. 元の「API接続の編集」画面へ戻って、「保存」を選択

    ![](../images/ex01-306.png)


## ロールの追加

1. Azureポータルにて作成したリソースグループを開き、左側の「アクセス制御(IAM)」を選択、[ロールの追加]-[ロールの割り当てを追加] を選択

1. ロールの割り当ての追加

    以下のロールを現在のユーザーに追加

    - Microsoft Sentinel Contributor (Microsoft Sentinel 共同作成者)
    - Microsoft Sentinel Automation Contributor (Microsoft Sentinel Automation 共同作成者)


## Denfederポータル に ワークスペース を接続

1. Defenderポータルを開く

    - [Defender ポータル](https://security.microsoft.com/)

1. [システム]-[設定] を開き、「Microsoft Sentinel」を選択


1. 「SIEM ワークスペース」にて、作成したワークスペースを選択して「ワークスペースの接続」を選択

    (*) 必要に応じて「プライマリワークスペース」を設定

