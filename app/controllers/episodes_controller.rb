class EpisodesController < ApplicationController
  before_filter :check_admin, :except => [:all, :index, :show, :tag, :tags, :latest]

  def index
    @tag = Tag.find(params[:tag_id]) if params[:tag_id]
    if params[:search].blank?
      @episodes = (@tag ? @tag.episodes : Episode).recent.page(params[:page]).per_page(20)
    else
      @episodes = Episode.search(
        query: {
          multi_match: {
            query: params[:search].to_s,
            fields: ["name", "description"]
          }
        },
        filter: {
          missing: {
            field: "revision"
          }
        }
      ).records
      @count = @episodes.size
      @paged_episodes = @episodes.page(params[:page]).per_page(20)
    end
    respond_to do |format|
      format.html
      format.rss
      format.json {render :json => @episodes}
    end
  end

  def latest
    @episodes = Episode.recent.page(params[:page]).per_page(12)
  end

  def tags
    @tags = Tag.all.sort_by{ |t| t.name.downcase }
  end
  def tag
    if Tag.find_by_name(params[:tag])
      @episodes = Tag.find_by_name(params[:tag]).episodes
    end
  end

  def show
    session[:return_to] = request.url
    @episode = Episode.find(params[:id])
    respond_to do |f|
      f.html
      f.json {render :json => @episode}
    end
  end

  def new
    @episode = Episode.new
    @default_time = Episode.last.nil? ? Time.now : Episode.last.published_at + 7.days
  end

  def create
    @episode = Episode.new(params[:episode])
    if @episode.save
      redirect_to @episode, :notice => "Successfully created episode."
    else
      render :new
    end
  end

  def edit
    @episode = Episode.find(params[:id])
  end

  def update
    @episode = Episode.find(params[:id])
    if @episode.update_attributes(params[:episode])
      redirect_to @episode, :notice => "Successfully updated episode."
    else
      render :edit
    end
  end
end
