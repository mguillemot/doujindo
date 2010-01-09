class FaqEntry < ActiveRecord::Base
  acts_as_tree :order => 'id'
  translatable_columns :toc_entry, :question, :answer

  def parts
    return [] if answer_avatar == nil
    res = []
    avatars = answer_avatar.split(/,/)
    answers = answer.split(/---/)
    0.upto([avatars.length, answers.length].max - 1) do |i|
      res << { :avatar => avatars[i], :answer => answers[i] }
    end
    res
  end
end
