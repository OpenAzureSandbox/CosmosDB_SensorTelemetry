# Cosmos DB Telemetry

## 注意点

**※ プライベートレポジトリで実行すること。**

## 概要

- 毎秒 Cosmos DB にセンサーデータを送信

## セットアップ方法

### 1. Terraform 認証用のサービスプリンシパル作成

```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/f0efe35e-b5a6-42ef-9a7a-e11fa99a1f8f"
Creating 'Contributor' role assignment under scope '/subscriptions/f0efe35e-b5a6-42ef-9a7a-e11fa99a1f8f'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
'name' property in the output is deprecated and will be removed in the future. Use 'appId' instead.
{
  "appId": "b11e11d5-5348-4747-95c8-d499d5e8b3ee",
  "displayName": "azure-cli-2022-01-07-09-00-15",
  "name": "b11e11d5-5348-4747-95c8-d499d5e8b3ee",
  "password": "iJOWAd0R_4~l3.HFER.ZCSDr-8hyyosf1c",
  "tenant": "72f988bf-86f1-41af-91ab-2d7cd011db47"
}
```

### 2. 作成したサービスプリンシパルのシークレットを GitHub のシークレットに格納

### 3. tfstate ファイル格納用の Blob Storage 作成

```
#!/bin/bash

RESOURCE_GROUP_NAME=tfstate
STORAGE_ACCOUNT_NAME=tfakskohei3110str  #ここは一意のものに変更
CONTAINER_NAME=tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
```

### 4. local.settings.json の作成

ローカル実行用に、`local.settings.sample.json` を参考に、`local.settings.json` を作成

```local.settings.json
{
    "IsEncrypted": false,
    "Values": {
      "AzureWebJobsStorage": "UseDevelopmentStorage=true",
      "FUNCTIONS_WORKER_RUNTIME": "node",
      "MyConnectionString": "AccountEndpoint=<AccountEndpoint>;AccountKey=<AccountKey>;"
    }
}
```

### 5. 認証情報の構成

`./azure/env/demo/main.tf` の以下の部分をご自分のものと置換

```
provider "azurerm" {
  features {}

  subscription_id = "<YOUR_SUBSCRIPTION_ID>"
  tenant_id       = "<YOUR_TENANT_ID>"
  client_id       = "<YOUR_CLIENT_ID>"
  client_secret   = "<YOUR_CLIENT_SECRET>"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "<YOUR_STORAGE_ACCOUNT_NAME>"
    container_name       = "tfstate"
    key                  = "cosmossample.tfstate"
  }
}
```

## To Do

- EventHub を挟んでデータ取得？