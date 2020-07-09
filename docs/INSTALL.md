# How to install CIB database

The initial process of `CIB` is the extraction of firms from scoreboard and then from these list, we extract the selected companies from the Orbis database. After this first work we have to use the PAM System in order to match all the entities with the RISIS Patent database, those first steps are well described in the README file of this repository, but here you will find the process for producing the actual database, that means, using the result we got from Pam system and the information gather from our 3 data sources (RISIS Patent database, ORBIS and scoreboard) we built a relational database following the tutorial here presented. Please, if you have faced any difficulty reproducing these steps, we encourage you to open a new issue in our repository.

### 1. Extract from orbis all the firms information as xls and then export it into csv file.

First we will need to download the data from orbis in xls format (For cib we have chosen the financial data, addresses information, sectors, names and views). Those files usually contain two sheets, the first one has the summary of the extraction made in orbis and the second one will have the actual data. Therefore in order to import this data in mysql we will need first to export all these data as csv file format (just the sheet with the actual data) defining as "field delimiter" the comma (,) and for the string delimiter we will use double quote (").



### 2. Create temporary tables and production tables



### 3. Load the data extracted from orbis 



### 4. Run the scripts in /src in order



### 5. Run and update the unit tests

