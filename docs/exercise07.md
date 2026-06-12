# Exercise07: 脅威インテリジェンス

#### ⏳ 推定時間: 20分

#### 💡 学習概要

Microsoft Sentinel Threat Intelligence (TI) の機能と製品統合ポイントの使用方法を説明します。
このモジュールでは、モジュール 2で取り込んだ TI データを使用するため、そのモジュールを完了していることを確認してください。
このモジュールでは、調査と検出の一環としてこのデータを視覚化して使用する方法についても説明します。

#### 🗒️ 目次

1. [Microsoft Defender 脅威インテリジェンス (MDTI) を接続](#microsoft-defender-脅威インテリジェンス-mdti-を接続)
1. [脅威インテリジェンスデータコネクタ](#脅威インテリジェンスデータコネクタ)
1. [取り込まれた脅威インテリジェンスの確認](#取り込まれた脅威インテリジェンスの確認)
1. [脅威インテリジェンスに基づく分析ルールの有効化](#脅威インテリジェンスに基づく分析ルールの有効化)
1. [脅威インテリジェンス ワークブックの作成](#脅威インテリジェンス-ワークブックの作成)


## Microsoft Defender 脅威インテリジェンス (MDTI) を接続

(*) [Exercise02](./exercise02.md) でインストールおよび接続済みの場合、本手順はスキップします。

#### 脅威インテリジェンス コンテンツの追加

1. [Defender ポータル](https://security.microsoft.com/) を開く
1. [Microsoft Sentinel]-[コンテンツ管理]-[コンテンツハブ] を開く
1. `Threat Intelligence` を選択、「インストール」

#### 脅威インテリジェンスを接続

1. [Microsoft Sentinel]-[構成]-[データコネクタ] を開く
1. `Microsoft Defender Threat Intelligence` を選択、「コネクタページを開く」
1. 「接続」を選択


<div style="text-align: center; font-size: 1.2em; font-weight: bold; margin: 4em;">
～ しばらく待ち (数分程度) ☕☕☕ ... ～
</div>

## 脅威インテリジェンスデータコネクタ

このコネクタは Microsoft 脅威インテリジェンス インジケーターを `ThreatIntelIndicators` (旧 `ThreatIntelligenceIndicator`) テーブルに自動的に取り込みます。
MDTI は、追加コストなしで一連のインジケーターと https://ti.defender.microsoft.com ポータルへのアクセスを提供し、MDTI ポータルと API のプレミアム機能にはライセンスが必要です。

以下の手順でデータコネクタの接続と取り込まれた脅威インテリジェンスを確認します。

1. [Microsoft Sentinel]-[構成]-[データコネクタ] を開く

    ![](../images/ex07/0101.png)

1. `Microsoft Defender Threat Intelligence` を検索して開く

    データを受信し、インジケーターを取り込んでいることを確認します。
    問題なく接続、受信できている場合、 **"Status" が "Connected"** になっています。
    もし、上記以外の場合、再接続を試します。

    ![](../images/ex07/0102.png)

1. [脅威インテリジェンス]-[Intel の管理] を開く

    ![](../images/ex07/0103.png)

1. 取り込まれた脅威インテリジェンスを確認

    ![](../images/ex07/0104.png)



## 取り込まれた脅威インテリジェンスの確認

脅威インテリジェンス (TI) データを Microsoft Sentinel に取り込む方法はいくつかあります。
利用可能な多くの統合脅威インテリジェンスプラットフォーム(TIP)製品のいずれかを使用することも、TAXIIサーバーに接続してSTIX互換の脅威インテリジェンスフィードを利用することもできます。

#### 「ログ」から脅威インテリジェンスを確認

これらの TI フィードのいずれかから取り込まれた 侵害の兆候 (Indicators of Compromise, IOC) は、 `ThreatIntelIndicators` (旧 `ThreatIntelligenceIndicator`) と呼ばれる専用のテーブルに格納され、左側のナビゲーション メニューの [脅威インテリジェンス] メニューに表示されます。

1. [調査と対応]-[追求]-[高度な追求] を開く

    ![](../images/ex07/0201.png)

1. 以下のクエリで `ThreatIntelIndicators` テーブルのスキーマを確認

    ```
    ThreatIntelIndicators
    | getschema
    ```

    ![](../images/ex07/0202.png)

1. 以下のクエリで テーブルから10件取得して内容を確認

    ```
    ThreatIntelIndicators
    | take 10
    ```

    特定のIOCがアクティブかどうかを理解するには、次の列を詳しく見る必要があります。

    - ValideUntil, ValidFrom [UTC]
    - IsActive

    この例では、IOCは有効期限内までアクティブなIPであることがわかります。
    つまり、マッチング検出ルール (次の演習で確認します) では、データ ソースと関連付けるときにこの IOC が考慮されます。

    ![](../images/ex07/0203.png)


#### 「脅威インテリジェンス」画面から脅威インテリジェンスを確認

TI データを `ThreatIntelIndicators` テーブルに取り込んだ後、私たちの使命は、SOC が TI メニューをどのように活用して管理し、IOC のライフサイクルを検索、タグ付け、管理できるかを確認することです。

1. [脅威インテリジェンス]-[Intelの管理] を開く

    ![](../images/ex07/0211.png)

1. 検索条件を確認

    メインブレードの上部領域「フィルター」を展開すると、特定のパラメーターに基づいてIOCリストをフィルタリングできます。
    この例では、1つのタイプのIOC(IP)のみを取り込みましたが、タイプフィルターを使用すると、さまざまなタイプに基づいてフィルタリングできます。複数の TI データ ソースから IOC を取り込んだ場合、ソース フィルターを使用するとスライスできます。

    ![](../images/ex07/0212.png)

1. 任意のIOCを選択

    選択したIOCのメタデータが右側ペインに表示されることを確認します。

    ![](../images/ex07/0213.png)


#### 「脅威インテリジェンス」画面から新しい脅威インテリジェンスを手動追加

SOCアナリストの仕事の一部は、IOCをTIインデックスに手動で追加することです。
これにより、他のデータソースと検出がこの IOC との相互作用を関連付けて検出できます。

1. [脅威インテリジェンス]-[Intelの管理] を開き、[新規]-[TIオブジェクト] を選択

    ![](../images/ex07/0221.png)

1. 新しいインジケーターを作成

    以下の設定をして「保存」

    - オブジェクトの種類: `インジケーター`
    - パターン: `パターンビルダー`
    - 新しい感しか能対象:
        - `url`: `http://phishing.com`
    - 名前: `URL Indicator`
    - 脅威の種類: `悪意のあるアクティビティ (malicious-activity)`
    - 有効期間の開始日: (今日の日付)
    - 有効期限: (2週間後の日付)
    - ソース: `Microsoft Sentinel` (デフォルトまま)
    - 説明: `このURLはインシデント4326にて検出`
    - タグ: `incident 4326`
    - 信頼度: `80`

    ![](../images/ex07/0222.png)

1. 作成したインジケーターがIOCリストにあることを確認

    ![](../images/ex07/0223.png)

1. [調査と対応]-[追求]-[高度な追求] を開く

    ![](../images/ex07/0224.png)

1. 以下のクエリを実行し、作成したIOCが `ThreatIntelIndicators ` テーブルに追加されていることを確認

    ```
    ThreatIntelIndicators
    | search "http://phishing.com"
    ```

    ![](../images/ex07/0225.png)

数日後、社内の TI チームから、この新しい IOC はもう関連性がなく、削除する必要があるという新しい情報を受け取りました。
作成した IOC を以下の手順で削除します。

1. [脅威インテリジェンス]-[Intelの管理] を開く

    ![](../images/ex07/0231.png)

1. 作成した IOC を検索して選択、上部メニュー「削除」を実施

    ![](../images/ex07/0232.png)


## 脅威インテリジェンスに基づく分析ルールの有効化

TI データの主な価値の 1 つは、分析ルールです。
この演習では、取り込んだ TI と相関する Microsoft Sentinel にある分析ルールの種類を確認します。

#### 脅威インテリジェンス 分析ルール を確認

1. [Microsoft Sentinel]-[構成]-[分析] を開き、「規則のテンプレート」タブへ移動

    ![](../images/ex07/0301.png)

1. 「フィルターの追加」を開き、以下の条件でフィルタ

    - データソース: `Microsoft Defender Threat Intelligence`

    ![](../images/ex07/0302.png)

1. TI一覧を確認

    結果のアラート テンプレートの長いリストがあります。
    これらはすべて、さまざまなデータ ソースを TI テーブル (`ThreatIntelIndicators`) に存在する IOC と関連付けて、組織のログ内の悪意のある侵害インジケーターのトレースを検出します。
    これらのルールの詳細については、[こちら](https://docs.microsoft.com/azure/sentinel/work-with-threat-indicators#detect-threats-with-threat-indicator-based-analytics) をご覧ください。

    ![](../images/ex07/0303.png)

Microsoft Sentinel で分析ルールを有効にすることは無料であるため、ベスト プラクティスは、取り込むデータ ソースに適用されるすべてのルールを有効にすることです。


#### 脅威インテリジェンス 分析ルール を有効化

1. 任意の分析ルール（例： `TI Map IP Entity to DeviceNetworkEvents` など）を選択して「ルールの作成」

    ![](../images/ex07/0311.png)

1. 分析ルールの作成

    1. 全般, ルールのロジックを設定, インシデントの設定, 自動応答

        デフォルトまま

    1. 確認と作成

        「保存」を選択

        ![](../images/ex07/0312.png)


## 脅威インテリジェンス ワークブックの作成

ブックは、Microsoft Sentinel のあらゆる側面に関する洞察を提供する強力な対話型ダッシュボードを提供し、脅威インテリジェンスも例外ではありません。
この演習では、Microsoft Sentinel の脅威インテリジェンスに関する重要な情報を視覚化するための専用ブックを探索します。

#### ワークブックの作成

1. [Microsoft Sentinel]-[脅威の管理]-[ブック] を開き、「テンプレート」タブへ移動

    ![](../images/ex07/0401.png)

1. `Threat Intelligence` を選択、「保存」を選択

    ![](../images/ex07/0402.png)

1. ブック保存先リージョン `Japan East` を指定して「はい」

    ![](../images/ex07/0403.png)

1. 「保存されたブックの表示」を選択

    ![](../images/ex07/0404.png)

1. 「Threat Intelligence ブック」の確認

    Sentinelにインポートされたインジケーターをタイプ別およびプロバイダー別に示す、事前に作成された視覚化がいくつか見つかります。
    新しいグラフを変更または追加するには、ページの上部にある [編集] ボタンを選択して、ブックの編集モードに入ります。

    ![](../images/ex07/0405.png)


#### ワークブックにグラフ追加

1. 上部メニュー「編集」を選択

    ![](../images/ex07/0411.png)

1. 下端までスクロールし、[追加]-[データソースと視覚化の追加] を選択

    ![](../images/ex07/0412.png)

1. 以下のクエリを追加して「実行」、動作することを確認

    - データソース: `Log(Analytics)` (デフォルト)
    - リソースの種類: `microsoft.operationalinsights/workspaces` (デフォルト)
    - リソース: (Microsoft Sentinel ワークスペースを選択)
    - 時間の範囲: `過去 24 時間` (任意)
    - 視覚化: `クエリごとに設定`

    ```
    ThreatIntelIndicators
    | mv-expand indicator_type = Data.indicator_types
    | extend indicator_type = tostring(indicator_type)
    | where isnotempty(indicator_type)
    | summarize count() by indicator_type
    | order by count_ desc
    ```

    ![](../images/ex07/0413.png)

1. 以下を設定して、上部「編集完了」を選択して保存

    - 視覚化: `横棒グラフ`
    - グラフタイトル: `Indicator Type Distribution in ThreatIntelIndicators`

    ![](../images/ex07/0414.png)

以上でワークブックの新しいグラフが作成できました😀


