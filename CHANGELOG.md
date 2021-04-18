# Changelog

## [v0.2.0](https://github.com/solidusio-contrib/solidus_importer/tree/v0.2.0) (2021-04-07)

[Full Changelog](https://github.com/solidusio-contrib/solidus_importer/compare/v0.2.0...v0.2.0)

**Closed issues:**

- Prepare Solidus Importer for Solidus 3.0 [\#49](https://github.com/solidusio-contrib/solidus_importer/issues/49)
- Missing option\_type [\#48](https://github.com/solidusio-contrib/solidus_importer/issues/48)

**Merged pull requests:**

- Let the extension work with ActiveStorage [\#57](https://github.com/solidusio-contrib/solidus_importer/pull/57) ([MinasMazar](https://github.com/MinasMazar))
- Update gemspec with correct Github organization [\#52](https://github.com/solidusio-contrib/solidus_importer/pull/52) ([MinasMazar](https://github.com/MinasMazar))
- Fix option types and values processors [\#47](https://github.com/solidusio-contrib/solidus_importer/pull/47) ([stefano-sarioli](https://github.com/stefano-sarioli))
- Update to the latest dev-support template and allow usage of Solidus 3.0 [\#46](https://github.com/solidusio-contrib/solidus_importer/pull/46) ([MinasMazar](https://github.com/MinasMazar))
- Skip empty option values [\#45](https://github.com/solidusio-contrib/solidus_importer/pull/45) ([derrickp](https://github.com/derrickp))
- Do not add taxon if it's on the product [\#44](https://github.com/solidusio-contrib/solidus_importer/pull/44) ([derrickp](https://github.com/derrickp))
- OptionTypes loaded from DB instead of off product [\#43](https://github.com/solidusio-contrib/solidus_importer/pull/43) ([derrickp](https://github.com/derrickp))

## [v0.2.0](https://github.com/solidusio-contrib/solidus_importer/tree/v0.2.0) (2020-10-23)

[Full Changelog](https://github.com/solidusio-contrib/solidus_importer/compare/v0.1.0...v0.2.0)

**Closed issues:**

- Error messages leak from one row to the other [\#35](https://github.com/solidusio-contrib/solidus_importer/issues/35)
- Missing billing and shipping address for customers [\#34](https://github.com/solidusio-contrib/solidus_importer/issues/34)
- SolidusImporter::Processors::Address tries to import the wrong state and fails [\#33](https://github.com/solidusio-contrib/solidus_importer/issues/33)
- Reconsider adding an address to the imported StockLocation [\#31](https://github.com/solidusio-contrib/solidus_importer/issues/31)
- Test the importer with data coming from a sample Shopify store [\#16](https://github.com/solidusio-contrib/solidus_importer/issues/16)

**Merged pull requests:**

- Fix replication of shipping methods [\#42](https://github.com/solidusio-contrib/solidus_importer/pull/42) ([MinasMazar](https://github.com/MinasMazar))
- Package new release [\#41](https://github.com/solidusio-contrib/solidus_importer/pull/41) ([MinasMazar](https://github.com/MinasMazar))
- Fix a typo in the readme [\#40](https://github.com/solidusio-contrib/solidus_importer/pull/40) ([elia](https://github.com/elia))
- Enhance order importer [\#39](https://github.com/solidusio-contrib/solidus_importer/pull/39) ([MinasMazar](https://github.com/MinasMazar))
- Find another way to "preserve context between rows processing" [\#38](https://github.com/solidusio-contrib/solidus_importer/pull/38) ([MinasMazar](https://github.com/MinasMazar))
- Fix customer addresses processor [\#37](https://github.com/solidusio-contrib/solidus_importer/pull/37) ([MinasMazar](https://github.com/MinasMazar))
- Update binstubs [\#36](https://github.com/solidusio-contrib/solidus_importer/pull/36) ([MinasMazar](https://github.com/MinasMazar))
- Store entities on context and trigger post-processors after the import [\#30](https://github.com/solidusio-contrib/solidus_importer/pull/30) ([MinasMazar](https://github.com/MinasMazar))
- Update customers.csv fixture and customer related processors [\#28](https://github.com/solidusio-contrib/solidus_importer/pull/28) ([MinasMazar](https://github.com/MinasMazar))
- Add an entry about usage from the backend w/ GIFs! [\#27](https://github.com/solidusio-contrib/solidus_importer/pull/27) ([elia](https://github.com/elia))

## [v0.1.0](https://github.com/solidusio-contrib/solidus_importer/tree/v0.1.0) (2020-06-26)

[Full Changelog](https://github.com/solidusio-contrib/solidus_importer/compare/d017b016016a388ba0346c217763aae9a4a8636c...v0.1.0)

**Closed issues:**

- Implement an Options processor \(for products\) [\#15](https://github.com/solidusio-contrib/solidus_importer/issues/15)
- Implement a Taxon processor \(for products\) [\#14](https://github.com/solidusio-contrib/solidus_importer/issues/14)
- Roadmap [\#5](https://github.com/solidusio-contrib/solidus_importer/issues/5)
- Version 1.0 [\#4](https://github.com/solidusio-contrib/solidus_importer/issues/4)

**Merged pull requests:**

- Update to the latest solidus-dev-support templates + UI improvements [\#25](https://github.com/solidusio-contrib/solidus_importer/pull/25) ([elia](https://github.com/elia))
- Add Taxon processors [\#23](https://github.com/solidusio-contrib/solidus_importer/pull/23) ([MinasMazar](https://github.com/MinasMazar))
- Fix product/variant processors according to Shopify Product CSVs [\#22](https://github.com/solidusio-contrib/solidus_importer/pull/22) ([MinasMazar](https://github.com/MinasMazar))
- Fix and improve customer processor [\#21](https://github.com/solidusio-contrib/solidus_importer/pull/21) ([MinasMazar](https://github.com/MinasMazar))
- Implement product options processors [\#20](https://github.com/solidusio-contrib/solidus_importer/pull/20) ([MinasMazar](https://github.com/MinasMazar))
- Improve processors context [\#13](https://github.com/solidusio-contrib/solidus_importer/pull/13) ([blocknotes](https://github.com/blocknotes))
- Packaging for 1.0 [\#11](https://github.com/solidusio-contrib/solidus_importer/pull/11) ([blocknotes](https://github.com/blocknotes))
- Update specs removing unnecessary destroys because of database\_cleaner [\#10](https://github.com/solidusio-contrib/solidus_importer/pull/10) ([blocknotes](https://github.com/blocknotes))
- Structure improvements [\#9](https://github.com/solidusio-contrib/solidus_importer/pull/9) ([blocknotes](https://github.com/blocknotes))
- Images processing [\#8](https://github.com/solidusio-contrib/solidus_importer/pull/8) ([blocknotes](https://github.com/blocknotes))
- Update the README to open the project to the public [\#7](https://github.com/solidusio-contrib/solidus_importer/pull/7) ([blocknotes](https://github.com/blocknotes))
- Admin UI [\#3](https://github.com/solidusio-contrib/solidus_importer/pull/3) ([blocknotes](https://github.com/blocknotes))
- Background processing [\#2](https://github.com/solidusio-contrib/solidus_importer/pull/2) ([blocknotes](https://github.com/blocknotes))
- Main structure [\#1](https://github.com/solidusio-contrib/solidus_importer/pull/1) ([blocknotes](https://github.com/blocknotes))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
