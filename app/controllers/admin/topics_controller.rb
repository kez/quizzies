class Admin::TopicsController < Admin::AdminController
  def index
    @records = Topic.order(:title).all
  end

  def edit
    @record = Topic.find(params[:id])
  end

  def update
    topic_params = params.require(:topic).permit!

    @record = Topic.find(params[:id])
    @record.update(topic_params)

    redirect_to admin_topics_url, flash: {success: "Updated"}
  end

  private

  def set_breadcrumbs
    super
    @breadcrumbs << ["Topics Admin", admin_topics_url]
  end
end
