class StoriesController < ApplicationController
  def index
    @stories = Story.order(created_at: :desc).paginate(per_page: 9, page: params[:page])
    @speaker = Speaker.all

    @meta_title = meta_title 'Upcoming'
    @webinar = Webinar.order(date: :asc).limit(4)
    @webinars = Webinar.order(date: :asc).limit(2)
  end
  def home
    @stories = Story.order(created_at: :desc).limit(9)
    @speaker = Speaker.all

    @meta_title = meta_title 'Home'
    @webinar = Webinar.order(date: :asc).limit(4)
    @webinars = Webinar.order(date: :asc).limit(2)
  end

  def all
    @stories = Story.order(created_at: :desc).paginate(per_page: 9, page: params[:page])
    authorize @stories
  end

  def show
    @stories = Story.friendly.find(params[:id])
    @speaker = @stories.speaker
    @meta_title = meta_title @stories.title
    @meta_description = @stories.quote.gsub('“','')

    @meta_keyword = @stories.slug.gsub('-', ',')
    @root_path = root_path
    @canonical_url = "https://zynau.com/stories/#{@stories.slug}"
    @og_properties = {
      title: @meta_title,
      type:  'website',
      image: view_context.image_url(@stories.image),  # this file should exist in /app/assets/images/logo.png
      url: @canonical_url
      }
  end

  def new
      @stories = Story.new
      @speaker = Speaker.all
      authorize @stories
  end

  def create
    @stories = Story.new(resource_params)
    @stories.save
    redirect_to admin_stories_all_path
  end

  def edit
      @stories = Story.friendly.find(params[:id])
      @speaker = Speaker.all
      authorize @stories

  end

  def update
    @stories = Story.friendly.find(params[:id])
    @stories.update(resource_params)
    authorize @stories
    redirect_to admin_stories_all_path
  end

  def destroy
    @stories = Story.friendly.find(params[:id])
    @stories.destroy
    authorize @stories
    redirect_to admin_stories_all_path
  end

  private

  def resource_params
    params.require(:story).permit(:title, :content, :quote, :image, :video, :date, :status, :speaker_id)
  end

end
