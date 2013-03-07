class PeopleController < ApplicationController
  before_filter :optionally_protect_with_http_basic_auth
  before_filter :optionally_set_cors_headers

  # GET /people
  # GET /people.json
  def index
    person = Person.new(name: 'Chris', age: 32) do |p|
      p.created_at = p.updated_at = Time.now
      p.id = 1
    end
    @people = [person]

    respond_to do |format|
      format.html { redirect_to people_path(format: 'json') }
      format.json { render json: @people }
    end
  end

  private

  def optionally_protect_with_http_basic_auth
    return unless params[:enable_http_auth]
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == 'username' && password == 'password'
    end
  end

  def optionally_set_cors_headers
    return unless params[:enable_cors_headers]
    headers['Access-Control-Allow-Origin'] = request.headers['Origin'] if request.headers['Origin']
    headers['Access-Control-Allow-Credentials'] = 'true'
  end
end
