# Medical-Predictions-Database-Design-and-Analysis
Analysis of several prescription data to understand more about the types of medication being  prescribed, the organisations doing the prescribing, and the quantities prescribed. 

## The Data
These files are an excerpt from a larger file which is a real-world dataset released every month by 
the National Health Service (NHS) in England. The file provides a information on prescriptions 
which have been issued in England, although the extract we have provided focusses 
specifically on Bolton. 
The data includes three related tables, which are provided in three csv files: </br>
• The Medical_Practice.csv file has 60 records and provides the names and addresses of 
the medical practices which have prescribed medication within Bolton. The 
PRACTICE_CODE column provides a unique identifier for each practice.</br>
• The Drugs.csv file provides details of the different drugs that can be prescribed. This 
includes the chemical substance, and the product description. The 
BNF_CHAPTER_PLUS_CODE column provides a way of categorising the drugs based on 
the British National Formulatory (BNF) Chapter that includes the prescribed product. 
For example, an antibiotic such as Amoxicillin is categorised under ‘05: Infections’. The 
BNF_CODE column provides a unique identifier for each drug.</br>
• The Prescriptions.csv file provides a breakdown of each prescription. Each row 
corresponds to an individual prescription, and each prescription is linked to a practice 
via the PRACTICE_CODE and the drug via the BNF_CODE. It also specifies the quantity 
(the number of items in a pack) and the items (the number of packs). The 
PRESCRIPTION_CODE column provides a unique identifier for each prescription.
