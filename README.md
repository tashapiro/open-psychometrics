# Open Psychometrics

Project collecting and analyzing data from the **[Open-Source Psychometrics Project](https://openpsychometrics.org/)**. The datasets include information about characters from different universes and their respective personality traits. Personality traits are based on user assessments from a questionnaire (e.g. how neat/messy is this character compared to another character). I randomly selected 61 different univereses (e.g. Game of Thrones, Bob's Burgers, Westworld, etc) and collected information about their respective characters.

About the Open-Source Psychometrics Project (excerpt from website):

> This website provides a collection of interactive personality tests with detailed results that can be taken for personal entertainment or to learn more about personality assessment. These tests range from very serious and widely used scientific instruments popular psychology to self produced quizzes. A special focus is given to the strengths, weaknesses and validity of the various systems.


## Data Dictionary

### Characters
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
