# The Corporate Invention Board Database (CIB)

The CIB (Corporate Invention Board) dataset is a database characterising the patent portfolios of the largest industrial firms worldwide. The CIB combines information extracted from the Industrial R&D Investment Scoreboard (EU Commission), the ORBIS financial database and the RISIS Patent database ( enriched version of the Patstat EPO database).

## Why CIB Database

The aim of cib is to facilitate a dataset for the analysis on the transformation of the global patent portfolios in the last two decades. Mainly regarding industrial groups with the highest R&D investments and their consolidated subsidiaries.

## How was it built

- Extraction of data from orbis database.
- Creating RPD database.
- Matching of entities using PAM System.
- Database Modeling and enrichment of geographical information.
- Conclusions

## Extraction of The ORBIS data

**ORBIS** has information on over 280 million companies across the globe. It’s the resource for company data. And it makes simple to compare companies internationally. Orbis is mostly used to find, analyse and compare companies for better decision making and increased efficiency.

For CIB was only taken in account the  the subsidiaries that are consolidated, that means, the subsidiaries wherein a company have more than 50% stock purchased of the outstanding common stock, therefore the assets, liabilities, equity, income, expenses and cash flows of the parent company and its subsidiaries is presented as those of a single economic entity.


#### Criteria 2

Still with a remaining good amount of the subsidiaries without being analyzed, was used the fields subs_total and subs_direct to determine the rest of consolidated subsidiaries. In ORBIS, "subs_directs" is the "Percentage Owned Direct" where a consolidate entity is represented by the "WO" (wholly owned) code or "MO" (majority owned) code, these symbolize 100% and >50.1% of ownership respectively. Subs_total is the "Percentage Owned Total", this variable is a combination of numbers and string representations such as '>75.00'. Thus the following script extracts all these cases and create a new table with the final filter. (The list of subs_direct values was obtained by doing a `distinct` selection over the field)  
