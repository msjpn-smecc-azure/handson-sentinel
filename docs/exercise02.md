# Exercise02: データコネクタ

#### ⏳ 推定時間: 15分

#### 💡 学習概要

Microsoft Sentinel にデータ コネクタをインストールして有効にし、さまざまなソースからアラートやテレメトリを取り込む方法を学習します。

#### 🗒️ 目次

1. [Azure アクティビティ コネクタ を有効化](#azure-アクティビティ-コネクタ-を有効化)
1. [Microsoft Defender for Cloud データ コネクタ を有効化](#microsoft-defender-for-cloud-データ-コネクタ-を有効化)
1. [Microsoft Defender 脅威インテリジェンス コネクタを有効化](#microsoft-defender-脅威インテリジェンス-コネクタを有効化)


> [!IMPORTANT]  
> Defenderポータル では複数のワークスペースを同時に確認可能になっています。
> Defenderポータル で Microsoft Sentinel を開いたのち、まずは **操作したいワークスペースになっていることを確認** します。
> 現在のワークスペースの確認は **Microsoft Sentinel 関連の画面右上「ワークスペース」から確認** できます。

## Azure アクティビティ コネクタ を有効化

Azure アクティビティ データ コネクタを有効にする方法を解説します。
このコネクタは、Azure 管理プレーン アクティビティからログをインポートし、サブスクリプション内の Azure 管理アクティビティを追跡できるようにします。

1. Defender ポータルを開く

    - [Defender ポータル](https://security.microsoft.com/)

1. [MicrosoftSentinel]-[コンテンツ管理]-[コンテンツハブ] を開く

    <!-- ![](../images/ex02-101.png) -->

1. `Azure Activity` を検索して選択、「インストール」を実行

    <!-- ![](../images/ex02-102.png) -->

1. [MicrosoftSentinel]-[構成]-[データコネクタ] を開く

    <!-- ![](../images/ex02-103.png) -->

1. `Azure Activity` を選択、「コネクターページを開く」を選択

    <!-- ![](../images/ex02-104.png) -->

1. 「手順」を下へスクロールして「構成」にある「[Azure Policy の割り当て]ウィザードの起動」を選択（Azureポータルへ遷移）

    <!-- ![](../images/ex02-105.png) -->

1. ポリシーの割り当て

    1. 基本

        - スコープ: (ご自身のサブスクリプションを選択)
        - ポリシー定義: `指定された Log Analytics ワークスペースにストリーミングするように Azure アクティビティ ログを構成します (Configure Azure Activity logs to stream to specified Log Analytics workspace)`
        - 割り当て名: `指定された Log Analytics ワークスペース (YOUR_LOG_ANALYTICS_WORKSPACE_NAME) にストリーミングするように Azure アクティビティ ログを構成します` (デフォルト入力されていますが、送信先 Log Analytics ワークスペース名 がわかるような名前に変更を推奨)

        <!-- ![](../images/ex02-106.png) -->

    1. パラメーター

        - プライマリ Log Analytics ワークスペース: (今回のハンズオン用に作成したワークスペース)

        <!-- ![](../images/ex02-108.png) -->

    1. 修復

        - 修復タスクを作成する: `有効`
            - 修復ポリシー: `指定された Log Analytics ワークスペースにストリーミングするように Azure アクティビティ ログを構成`

    1. マネージドID
    
        - マネージドIDを作成します: `有効`
        - マネージドID の種類: `システム割り当て`
        - システム割り当てIDの場所: (Log Analytics ワークスペースと同じ場所)

        <!-- ![](../images/ex02-109.png) -->

    1. 非準拠メッセージ

        デフォルトまま

        <!-- ![](../images/ex02-110.png) -->

    1. 確認および作成

        「作成」を選択

        <!-- ![](../images/ex02-111.png) -->

1. [コンテンツ管理]-[コンテンツハブ] を開き、`Azure Activity` を検索して選択、「管理」を開く

    <!-- ![](../images/ex02-112.png) -->

1. 管理ビューを確認

    管理ビューには、ソリューションの内容が表示されます。
    ソリューション パックに含まれるコネクタ、分析ルール、ワークブック、ハンティング クエリ、その他のコンテンツがここに表示されます。
    これらがインストールされると、それぞれが Sentinel インターフェイスの関連セクションに表示されます (分析ルール テンプレート、ワークブック テンプレートなど)。

    <!-- ![](../images/ex02-113.png) -->


## Microsoft Defender for Cloud データ コネクタ を有効化

Microsoft Defender for Cloud データ コネクタを有効にする方法を説明します。
このコネクタを使用すると、Microsoft Defender for Cloud からのセキュリティ アラートを Microsoft Sentinel にストリーミングできるため、Defender からのアラートを組み込み、ブックで Defender データを表示し、インシデントを調査して対応することができるようになります。

**注意:** この演習を実行するには、以下が必要です。<br />
・ユーザーがサブスクリプションでセキュリティ リーダーロールを持っている必要があります。<br />
・Microsoft Defender for Cloud でいずれかの Defender プランを有効にする必要があります。


1. [コンテンツ管理]-[コンテンツハブ] を開き、`Microsoft Defender for Cloud` を検索して選択、「インストール」を実行

    <!-- ![](../images/ex02-201.png) -->

1. デプロイが完了したら「管理」を開く

    <!-- ![](../images/ex02-202.png) -->

1. `Tenant-based Microsoft Defender for Cloud` のデータコネクタを選択、「コネクタページを開く」を押下（Azureポータルへ遷移）

    <!-- ![](../images/ex02-203.png) -->

1. 「構成」の「接続」を選択

    <!-- ![](../images/ex02-204.png) -->


## Microsoft Defender 脅威インテリジェンス コネクタを有効化

Microsoft Defender Threat Intelligence ( MDTI ) コネクタを Sentinel ワークスペースに追加します。
これにより、Microsoft Threat Intelligence インジケーターが `ThreatIntelligenceIndicator` テーブルに自動的に取り込まれます。
MDTI は、一連のインジケーターと https://ti.defender.microsoft.com ポータルへのアクセスを追加料金なしで提供しますが、MDTI ポータルと API のプレミアム機能にはライセンスが必要です。

1. [コンテンツ管理]-[コンテンツハブ] を開き、`Threat Intelligence` を検索して選択、「インストール」を実行

    <!-- ![](../images/ex02-301.png) -->

1. デプロイが完了したら「管理」を開く

    <!-- ![](../images/ex02-302.png) -->

1. `Microsoft Defender Threat Intelligence` のデータコネクタを選択、「コネクタページを開く」を押下

    <!-- ![](../images/ex02-303.png) -->

1. 「構成」にて以下を設定して「接続」

    - Import indicators: `At most one month old` (過去1か月以内のインジケーター)

    <!-- ![](../images/ex02-304.png) -->

