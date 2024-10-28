# Microsoft Sentinel Hands-on

![logo](./images/sentinel-labs-logo.png)

## 目的

本ハンズオンを通して Sentinel の各種機能について学びます。

## 目標

Microsoft Sentinel に含まれる以下のような機能について学習します。
- データコネクタ
- 分析ルール
- インシデント管理
- ハンティング

## 対象

以下のような方を対象として想定しています。

* クラウド管理者​
* クラウドアーキテクト​
* ネットワークエンジニア​
* セキュリティ管理者​
* セキュリティアーキテクト

## 前提条件

Microsoft Sentinel トレーニング ラボを展開するには、Microsoft Azure サブスクリプションが必要です。
既存の Azure サブスクリプションがない場合は、[こちら](https://azure.microsoft.com/free/) から無料試用版にサインアップできます。

**同一テナントで複数ユーザーが同時に本ハンズオンを実施する場合**、ユーザーごとにリソースグループを作成して権限付与を行ってください。
同一リソースグループで実施するとうまくテストデータがデプロイできない場合があります。

## ハンズオン 演習

1. [Microsoft Sentinel 利用環境の準備](./docs/exercise01.md) (20分)
1. [データコネクタ](./docs/exercise02.md) (15分)
1. [分析ルール](./docs/exercise03.md) (30分)
1. [インシデント管理](./docs/exercise04.md) (60分)
1. [ハンティング](./docs/exercise05.md) (40分)
1. [ウォッチリスト](./docs/exercise06.md) (20分)
1. [脅威インテリジェンス](./docs/exercise07.md) (20分)

## 参考

- [Microsoft Sentinel Training Lab](https://github.com/Azure/Azure-Sentinel/blob/master/Solutions/Training/Azure-Sentinel-Training-Lab/README.md)