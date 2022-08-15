# Open Psychometrics

## About

Project collecting and analyzing data from the **[Open-Source Psychometrics Project](https://openpsychometrics.org/)**. The datasets include information about characters from different universes and their respective personality traits. 

About the Open-Source Psychometrics Project (excerpt from website):

> This website provides a collection of interactive personality tests with detailed results that can be taken for personal entertainment or to learn more about personality assessment. These tests range from very serious and widely used scientific instruments popular psychology to self produced quizzes. A special focus is given to the strengths, weaknesses and validity of the various systems.

## Data

I randomly selected **100** different univereses (e.g. Game of Thrones, Bob's Burgers, Westworld, etc) and collected information about their respective characters. Dataset includes information on **890** characters total. Information for the entire project can also be downloaded directly from [opensychometrics.org](https://openpsychometrics.org/tests/characters/data/). Note, the full zip files are codified - i.e. characteters and questions are expressed as varchar IDs and require lookups.

There are a total of 400 different personality questions (that's a lot of traits!). One recommendation from the project suggests this data can be used for cool projects like dimension reduction - i.e. which traits are similar and convey the same info? 

Information about [Scoring](https://openpsychometrics.org/tests/characters/development/) from their site:

>The idea of this test is to match takers to a fictional character based on similarity of personality.

>A fictional character does not have a real personality, but people might perceive it to have one. It is unknown if this perception of personality actually has the same structure as human individual differences.

>This test assumes that a character's assumed personality is reflected in the average ratings of individuals. To collect this data a survey was developed. In it, the volunteer respondent rates 30 characters on 1 trait each, randomly drawn from a bank of 30 traits. With enough data, all the individual surveys can be combined into a comprehensive database of assumed personality.

## Dictionary

### Characters

High level information about characters. Includes a **notability** score and links to related pages.

| **variable** | **type** | **description**                     |
|:-------------|:---------|:------------------------------------|
| id           | varchar  | Character ID                        |
| name         | varchar  | Character Name                      |
| uni_id       | varchar  | Universe ID, e.g. GOT               |
| uni_name     | varchar  | Universe Name, e.g. Game of Thrones |
| notability   | num      | Notability Score                    |
| link         | varchar  | Link to Character Page              |
| image_link   | varchar  | Link to Character Image             |

### Psychology Stats

Personality/Psychometric Stats per character.

| **variable**   | **type** | **description**                        |
|:---------------|:---------|:---------------------------------------|
| char_id        | varchar  | Character ID                           |
| char_name      | varchar  | Character Name                         |
| uni_id         | varchar  | Universe ID, e.g. GOT                  |
| uni_name       | varchar  | Universe Name, e.g. Game of Thrones    |
| question       | varchar  | Personality Question - e.g. messy/neat |
| personality    | varchar  | Character Personality, e.g. neat       |
| avg_rating     | num      | Score out of 100                       |
| rank           | int      | Rank                                   |
| rating_sd      | num      | Rating Standard Deviation              |
| number_ratings | int      | Number of Ratings (Responses)          |

### Myers-Briggs

Users who took the personal personality assessment tests were subsequently asked to self-identify their **Myers-Briggs** types. Dataset contains results.

| **variable**   | **type** | **description**                     |
|:---------------|:---------|:------------------------------------|
| char_id        | varchar  | Character ID                        |
| char_name      | varchar  | Character Name                      |
| uni_id         | varchar  | Universe ID, e.g. GOT               |
| uni_name       | varchar  | Universe Name, e.g. Game of Thrones |
| myers_briggs   | varchar  | Myers Briggs Type, e.g. ENFP        |
| avg_match_perc | num      | Percentage match                    |
| number_users   | int      | number of user respondents          |


## Related Data Visuals

There are tons of ways to explore this daat. Recently,  I used it to compare characters from **[Westworld](https://github.com/tashapiro/tanya-data-viz/tree/main/westworld)**.

![plot](https://github.com/tashapiro/tanya-data-viz/blob/main/westworld/plots/westworld-radar-plot.png)

