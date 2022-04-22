require_relative "../services/github_service"
require_relative "../poros/contributor"

class GithubFacade

  def create_repo
    name = repo_data[:name]
    Repo.new(name)
  end

  def create_contributors
    contributors_data.map do |data|
      Contributor.new(data)
    end
  end

  def service
    @_service ||= GithubService.new
  end

  def repo_data 
    @_repo_data ||= service.get_repo
  end

  def contributors_data
    @_contributors_data ||=service.get_contributors
  end
end
