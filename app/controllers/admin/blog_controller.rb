class Admin::BlogController < Admin::AdminController
  def index
    @title = "Blog Admin"
    @records = Blog.order(Arel.sql("published_at desc nulls first")).all
  end

  def new
    @record = Blog.new
  end

  def edit
    @record = Blog.find(params[:id])
  end

  def update
    blog_params = params.require(:blog).permit!

    @record = Blog.find(params[:id])
    @record.update(blog_params)

    redirect_to admin_blog_index_url, flash: {success: "Updated"}
  end

  def create
    # Operations::News::Create.call(params: params.require(:news).permit!)
    blog_params = params.require(:blog).permit!
    Blog.create(blog_params)
    redirect_to admin_blog_index_url, flash: {success: "Created"}
  end

  private

  def set_breadcrumbs
    super
    @breadcrumbs << ["Blog Admin", admin_blog_index_url]
  end
end
