# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(user_name: 'robert')
User.create!(user_name: 'john')

Poll.create!(author_id: 1, title: "Programming Language")
Poll.create!(author_id: 2, title: "Power Ranger?")

Question.create!(poll_id: 1, text: "What's the best programming language?" )
Question.create!(poll_id: 1, text: "Why is it your favorite?" )
Question.create!(poll_id: 2, text: "Who is your favorite Power Ranger?" )
Question.create!(poll_id: 2, text: "Why does that Power Ranger resonate with you?" )

AnswerChoice.create!(question_id: 1, text: "Ruby")
AnswerChoice.create!(question_id: 1, text: "JavaScript")
AnswerChoice.create!(question_id: 2, text: "I know it")
AnswerChoice.create!(question_id: 2, text: "It's fun!")
AnswerChoice.create!(question_id: 3, text: "Red")
AnswerChoice.create!(question_id: 3, text: "Blue")
AnswerChoice.create!(question_id: 4, text: "He is not nerdy and I'm not either (trust me)")
AnswerChoice.create!(question_id: 4, text: "I like primary colors")

Response.create!(user_id: 1, answer_choice_id: 1)
Response.create!(user_id: 1, answer_choice_id: 3)
Response.create!(user_id: 1, answer_choice_id: 5)
Response.create!(user_id: 1, answer_choice_id: 7)
Response.create!(user_id: 2, answer_choice_id: 2)
Response.create!(user_id: 2, answer_choice_id: 4)
Response.create!(user_id: 2, answer_choice_id: 6)
Response.create!(user_id: 2, answer_choice_id: 8)
