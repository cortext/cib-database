
## UNIT TEST CIB DATABASE

    mysql  -t < main.sql
|table_name|expected_records|expected_columns|expected_data_types|expected_indexes|proportional_size|
|----------|----------------|----------------|-------------------|----------------|-----------------|
|cib_firm_address|4001|8ea78565413f1a67f2d15b25057f4121|e252275835dabd23d355b646e4f59545|b780b3cdf7af019d6ded12f1e26be708|1.00225|
|cib_firm_financial_data|11271|1315f35d7c8dbb7629183b6843070fd3|e252275835dabd23d355b646e4f59545|ad2b188f33daec91db650c77a74bb07d|2.8234|
|cib_firm_names|7234|68cbcfd62f2d20788435c77789e6939e|e252275835dabd23d355b646e4f59545|47acfe4164232128fb9fcacc6661426a|1.81212|
|cib_firm_sector|3992|03f20591fdce1cbd48df67d53b092805|e252275835dabd23d355b646e4f59545|62fea4099b6fdac6c565763adb8aece4|1|
|cib_firms|3992|ca0e84618b5f9a615b5b09b2fdf232f9|0f8e66026c1a947967e1cc9fa9f58b8c|5195709aa091ff80c92d64e14857158b|1|
|cib_patents_actors|6377887|658c879ffb4f3c340dd9e3392f8c3aeb|ae961e2ecf7b6697b3b7017b2d0aac27|a65a79a1d1c81e98a1b9cb74afe51b7f|1|
|cib_patents_inventors|15792193|143eb3f337a46ecf6360158b82ccd526|e6a95f5461b715256d09987643e0cbb8|e8171b46af83b62d6508d170c949f19a|2.47609|
|cib_patents_priority_attributes|6179588|83686f6d931c5f4bf8d6f9bacb648cd9|46771313e0ca9e407fd08aacc1527d9a|ff917ddc69fd216f2037b9f1b85f4f60|0.968908|
|cib_patents_technological_classification|18237980|f8204c5158b4af26fa9da20b5906c696|a1d302a4c2f8c7d62f296ffbc01b31e2|b89743327bfc09b30444ad1fc5df9cb8|2.85956|
|cib_patents_textual_information|6179588|f650195dd258f5e55f30c25d81148bf4|46771313e0ca9e407fd08aacc1527d9a|3e40b2438346c17a5387310d14157d75|0.968908|
|cib_patents_value|6179588|851da38865ff8a8716aae1220d8193eb|3ae829ee705d7ba61f487ea1fdd874a3|7d50aaaa76a705e2b28de5e49d009d38|0.968908|

|table_name|found_records|found_columns|found_data_types|found_indexes|
|----------|-------------|-------------|----------------|-------------|
|cib_firm_address|4001|8ea78565413f1a67f2d15b25057f4121|e252275835dabd23d355b646e4f59545|b780b3cdf7af019d6ded12f1e26be708|
|cib_firm_financial_data|11271|1315f35d7c8dbb7629183b6843070fd3|e252275835dabd23d355b646e4f59545|ad2b188f33daec91db650c77a74bb07d|
|cib_firm_names|7234|68cbcfd62f2d20788435c77789e6939e|e252275835dabd23d355b646e4f59545|47acfe4164232128fb9fcacc6661426a|
|cib_firm_sector|3992|03f20591fdce1cbd48df67d53b092805|e252275835dabd23d355b646e4f59545|62fea4099b6fdac6c565763adb8aece4|
|cib_firms|3992|ca0e84618b5f9a615b5b09b2fdf232f9|0f8e66026c1a947967e1cc9fa9f58b8c|5195709aa091ff80c92d64e14857158b|
|cib_patents_actors|6377887|658c879ffb4f3c340dd9e3392f8c3aeb|ae961e2ecf7b6697b3b7017b2d0aac27|a65a79a1d1c81e98a1b9cb74afe51b7f|
|cib_patents_inventors|15741537|143eb3f337a46ecf6360158b82ccd526|e6a95f5461b715256d09987643e0cbb8|e8171b46af83b62d6508d170c949f19a|
|cib_patents_priority_attributes|6179588|83686f6d931c5f4bf8d6f9bacb648cd9|46771313e0ca9e407fd08aacc1527d9a|ff917ddc69fd216f2037b9f1b85f4f60|
|cib_patents_technological_classification|18237980|f8204c5158b4af26fa9da20b5906c696|a1d302a4c2f8c7d62f296ffbc01b31e2|b89743327bfc09b30444ad1fc5df9cb8|
|cib_patents_textual_information|6179588|f650195dd258f5e55f30c25d81148bf4|46771313e0ca9e407fd08aacc1527d9a|3e40b2438346c17a5387310d14157d75|
|cib_patents_value|6179588|851da38865ff8a8716aae1220d8193eb|3ae829ee705d7ba61f487ea1fdd874a3|7d50aaaa76a705e2b28de5e49d009d38|


|table_name|records_exact_match|columns_match|data_type_match|indexes_match|consistency|
|----------|-------------------|-------------|---------------|-------------|-----------|
|cib_firm_address|ok|ok|ok|ok|ok|
|cib_firm_financial_data|ok|ok|ok|ok|ok|
|cib_firm_names|ok|ok|ok|ok|ok|
|cib_firm_sector|ok|ok|ok|ok|ok|
|cib_firms|ok|ok|ok|ok|ok|
|cib_patents_inventors|not ok|ok|ok|ok|ok|
|cib_patents_priority_attributes|ok|ok|ok|ok|ok|
|cib_patents_technological_classification|ok|ok|ok|ok|ok|
|cib_patents_textual_information|ok|ok|ok|ok|ok|
|cib_patents_value|ok|ok|ok|ok|ok|

---
### Summary

|summary|result|
|-------|------|
|records_count|fail|
|columns|ok|
|data_types|ok|
|indexes|ok|
|consistency|ok|
