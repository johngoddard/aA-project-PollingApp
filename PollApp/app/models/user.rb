class User < ActiveRecord::Base

  validates :user_name, presence: true


  has_many :authored_polls,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: :Poll

  has_many :responses,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Response


  def completed_polls

    Poll.joins(questions: :answer_choices)
        .joins("LEFT OUTER JOIN (SELECT responses.* FROM responses WHERE user_id = #{self.id}) a on a.answer_choice_id = answer_choices.id")
        .group("polls.id")
        .having("COUNT(DISTINCT(questions.id)) = COUNT(a.id)")

      # Poll.all
      #     .joins("LEFT OUTER JOIN questions ON questions.poll_id = polls.id")
      #     .joins("LEFT OUTER JOIN answer_choices ON answer_choices.question_id = questions.id")
      #     .eager_load(:responses)
      #     .group("polls.id")
      #     .having("COUNT(DISTINCT(questions.id)) = COUNT(a.id)")

  end

  def uncompleted_polls
    Poll.all - completed_polls
  end

end


#
#
# execute(<<-SQL, self.id)
#   SELECT
#     p.*
#   FROM
#     polls p
#   LEFT OUTER JOIN
#     questions q ON q.poll_id = p.id
#   LEFT OUTER JOIN
#     answer_choices a ON a.question_id = q.id
#   LEFT OUTER JOIN (
#     SELECT
#       responses.*
#     FROM
#       responses
#     WHERE
#       user_id = ?
#   ) user_r ON user_r.answer_choice_id = a.id
#   GROUP BY
#     p.id
#   HAVING
#     COUNT(DISTINCT q.id) = COUNT(user_r.id)
# SQL
#
#
# execute(<<-SQL, self.id)
#   SELECT
#     p.*,
#     COUNT(q.id) AS num_questions,
#     COUNT(r.id) AS num_responses
#   FROM
#     polls p
#   LEFT OUTER JOIN
#     questions q ON q.poll_id = p.id
#   LEFT OUTER JOIN
#     answer_choices a ON a.question_id = q.id
#   LEFT OUTER JOIN
#     responses r ON r.answer_choice_id = a.id
#   WHERE
#     r.user_id = 3
#   GROUP BY
#     p.id
#   HAVING
#     COUNT(q.id) =   COUNT(r.id)
# SQL
#
# SELECT
#   *
# FROM
#   polls p
# LEFT OUTER JOIN
#   questions q ON q.poll_id = p.id
# JOIN
#   answer_choices a ON a.question_id = q.id
# LEFT OUTER JOIN (
#   SELECT
#     responses.*
#   FROM
#     responses
#   WHERE
#     user_id = 3
# ) user_r ON user_r.answer_choice_id = a.id
# GROUP BY
#   p.id;
#
#   SELECT
#     *
#   FROM
#     polls p
#   LEFT OUTER JOIN
#     questions q ON q.poll_id = p.id
#   LEFT OUTER JOIN
#     answer_choices a ON a.question_id = q.id
#   LEFT OUTER JOIN
#     responses r ON r.answer_choice_id = a.id
#   WHERE
#     r.user_id = 3 OR  r.user_id is null
#   GROUP BY
#     p.id
#   HAVING
#     COUNT(q.id) =   COUNT(r.id)
