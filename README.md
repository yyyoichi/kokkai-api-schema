# kokkai-api-schema

国会会議録検索システム　検索用API の非公式OpenAPIスキーマです。

[https://kokkai.ndl.go.jp/api.html](https://kokkai.ndl.go.jp/api.html)

スキーマは、[https://yyyoichi.github.io/kokkai-api-schema/schema/openapi.yaml](https://yyyoichi.github.io/kokkai-api-schema/schema/openapi.yaml) です。

## Development

生成コマンド: `tsp compile main.tsp --emit @typespec/openapi3 --output-dir=docs`
