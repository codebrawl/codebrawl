require 'gist'

class GistValidator < ActiveModel::Validator

  def validate(document)
    gist = Gist.fetch(document.gist_id)
    return document.errors[:gist_id] << "does not exist" unless gist.code == 200
    return document.errors[:gist_id] << "can't be anonymous" unless gist['user']
    return document.errors[:gist_id] << "can't be public" if gist['public']
    document.errors[:gist_id] << "is not yours" unless document.user.github_id == gist['user']['id']
  end

end
