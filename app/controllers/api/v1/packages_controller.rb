class Api::V1::PackagesController < Api::V1::BaseController
  wrap_parameters :package, include: Package.attribute_names.map(&:to_sym).concat([:authors])

  def index
  end

  def show
  end

  def create
    # @package.authors = params[:authors]
    super
  end

  private

  def update_authors
    return unless params.has_key?(:authors)
    ids = []
    params[:authors].each do |author_hash|
      if author_hash[:id].nil?
        author = @package.authors.build(author_hash.permit(:name, :email))
      else
        author = @package.authors.find_by_id(author_hash[:id])
        next if author.nil?
        author.assign_attributes(author_hash.permit(:name, :email))
      end
      ids << author.id
    end
    @package.authors.where.not(id: ids).destroy_all
  end

  def package_params
    params.permit(:name, :short_description, :homepage, :description, authors: [:name, :email]).merge(user_id: current_user.id)
    # params.require(:package).permit(:name, :short_description, :homepage, :description, {authors: []}).merge(user_id: current_user.id)
  end

  def query_params
    params.permit(:name)
  end
end