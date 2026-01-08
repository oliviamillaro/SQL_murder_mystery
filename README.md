# 🕵️‍♂️ Knight Lab SQL Murder Mystery Solution

## 🧐 Overview
This repository contains my step-by-step solution to the [Knight Lab SQL Murder Mystery](https://mystery.knightlab.com/). This challenge covers SQL fundamentals including:
* `SELECT`, `FROM`, `WHERE`
* `HAVING`, `ORDER BY`
* Joins
* CTEs (Common Table Expressions)

## 📂 The Case
A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a **murder** that occurred sometime on **Jan. 15, 2018** and that it took place in **SQL City**. Start by retrieving the corresponding crime scene report from the police department’s database.
### 🗺️ The Data Schema
A data schema has been provided, and it is a great place to start thinking about how to solve the crime. `crime_scene_report` stands by itself and is probably a good place to start. So does `solution` but that's where you enter the solution so it is ok to leave that for now. Every other table is linked in various different ways and will be able to go through tables to link whatever we end up needing through the various keys.

<div align="center"><img width="815" height="399" alt="Image" src="https://github.com/user-attachments/assets/b5ef1514-2ad3-4adf-805a-e6e81acffb85" /></div>

---

## 🔍Step 1: Pulling the crime scene report
I went to see if I could pull the crime scene report using those key bits of information remembered about the crime so that we could understand more.

First, I need to understand how this table is structured and the data types so I can do a proper filtered query. The type and city make sense as strings as told us in the initial instructions, but date as an integer was confusing so I went and did a `SELECT *` from the table to see an example of how that date looks.

<div align="center">
  <img width="1049" height="479" alt="Image" src="https://github.com/user-attachments/assets/dee7f1d0-49a9-4204-9b7b-f8ed53a3fb85" />
</div>

Now I know exactly how to filter to the exact date I want to look at, and can type in all of those `WHERE` conditions to find the reports.

<div align="center">
  <img width="1042" height="406" alt="Image" src="https://github.com/user-attachments/assets/045caeb6-b945-4ea6-acda-5cd735d824c2" />
</div>

Luckily, there is only one report that matches all three of those requirements, so we can use this to investigate further.

---

## 🔍Step 2: Investigating witness reports
We have been given information about two witnesses that we can investigate further. There is a table called `interview` which we can probably find out some more. We need to identify them in the `person` table as we need the `person_id` to pull the correct interviews.

**Witness 1:**
Starting with the first witness, we have no name, but we do know that they live at the last house on “Northwestern Dr”. I used a `WHERE` clause to filter to the street, then ordered by `address_number` descending (largest to smallest), and then limited that to 1 so that I would get the last person on that street. That leaves **Morty Schapiro** who has an ID we can use later on.

<div align="center">
  <img width="859" height="386" alt="Image" src="https://github.com/user-attachments/assets/4050945f-136f-4baa-b634-1afab8b77459" />
</div>

**Witness 2:**
Whilst I am on this table I will go ahead and identify the other witness. This time we have a first name and a street name and that is it. I once again used a `WHERE` clause for the known street name, and then used a `LIKE` clause for name so that it would pick up anyone with Annabel as a first name, leaving me the witness I can use the id for.

<div align="center">
  <img width="924" height="335" alt="Image" src="https://github.com/user-attachments/assets/907aee93-ae7c-4d5e-998d-fae8bc4de77e" />
</div>

I can use these IDs and used those to filter the `interview` table to get those two given statements by the witnesses. That leaves us with the two interviews that we can now use to start narrowing down suspects.

<div align="center">
  <img width="1061" height="453" alt="Image" src="https://github.com/user-attachments/assets/5ac0b649-0be1-492a-9332-ad2b99ecce15" />
</div>

---

## 🔍Step 3: Narrowing down suspects
I can use the bits of information provided by the interview transcript from the individual with the `person_id` 14887 to narrow down the members of the gym.

<div align="center">
  <img width="798" height="426" alt="Image" src="https://github.com/user-attachments/assets/31c0aa19-3a0a-4b75-9827-b72c2ab550fd" />
</div>

This leaves us with two people who we can investigate further. We also had some information about a number plate, so I can then also look in the `drivers_license` table.

<div align="center">
  <img width="1057" height="601" alt="Image" src="https://github.com/user-attachments/assets/ef69a3ea-ce52-43e8-bb16-4c5e2a27ab42" />
</div>

This has given us 3 potential suspects but has not narrowed it down, so instead I can join this table to the `person` table to get some more information.

I can see that one of these individuals is one of the suspects we identified earlier when investigating the `get_fit_now_member` table, **Jeremy Bowers**. Joining again onto that `get_fit_now_member` table, `check_in` table, and adding all of the filters in from all of the information into one query to make sure we are 100% certain of who the killer is.

<div align="center">
  <img width="1041" height="524" alt="Image" src="https://github.com/user-attachments/assets/389ad435-b6b9-457c-b368-50da20874eb3" />
</div>

---

## 🔍Step 4: Finding the killer
Now I am quite convinced it is Jeremy Bowers, as he fits every single piece of evidence. I can follow the instructions to insert the name of the person I have identified and see if I am correct.

<div align="center">
  <img width="1042" height="424" alt="Image" src="https://github.com/user-attachments/assets/b8867de9-bc59-470c-8e05-38460f3a9dfb" />
</div>

We have correctly identified the killer! But it seems that the story doesn’t end here…

---

## 🔍Step 5: Finding the mastermind
When you go to query the `interview` transcript with the killer's `person_id`, this is what comes up:

<div align="center">
  <img width="834" height="302" alt="Image" src="https://github.com/user-attachments/assets/49999540-d3cd-49f9-82a4-c63f529836b0" />
</div>

This is quite a bit of information, that is housed in a few different tables. I knew that at the end I would need to create one bigger query combining all of the different tables of interest, but I began by breaking down that query into smaller ones to build up. First, I began by filtering down the `drivers_license` table.

<div align="center">
  <img width="697" height="486" alt="Image" src="https://github.com/user-attachments/assets/39533bcc-60d6-487a-b59b-7ee109b00a46" />
</div>

This narrowed it down to three people. Then I did a query on the `facebook_event_checkin` table.

<div align="center">
  <img width="441" height="458" alt="Image" src="https://github.com/user-attachments/assets/7a2e60c3-bbad-4b3d-8bcd-94786089fa58" />
</div>

Then, I brought together both of those queries using the `facebook_event_checkin` query as a CTE, and then joining that on to the other query to get a final suspect that meets all of the criteria.

<div align="center">
  <img width="834" height="724" alt="Image" src="https://github.com/user-attachments/assets/a95ee1c9-4ded-418a-916c-5fd18555b8e9" />
</div>

I feel convinced by this individual being the mastermind, so I put in the name into the solution query and we can see that we solved the case!

<div align="center">
  <img width="856" height="292" alt="Image" src="https://github.com/user-attachments/assets/4855c189-8c0b-43a7-b1f8-b45980e88ab9" />
</div>
