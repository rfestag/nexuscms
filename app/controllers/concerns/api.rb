module Api
  extend ActiveSupport::Concern

  module ClassMethods
    def model model
      define_method(:get_model) {model}
    end
  end

  def get_model_class
    get_model.to_s.camelize.constantize
  end
  def index
    objects = get_model_class.all
    respond_to do |format|
      format.json { render json: objects }
      format.xml { render xml: objects }
    end
  end
  def distinct
    vals = get_model.distinct params[:field]
    respond_to do |format|
      format.json { render json: vals }
      format.xml { render xml: vals }
    end
  end
  def show
    object = get_model_class.find(params[:id])
    respond_to do |format|
      format.json { render json: object }
      format.xml { render xml: object }
    end
  end
  def create
    object = get_model_class.new(get_model)
    respond_to do |format|
      if object.save
        format.json { render json: object, status: :created }
        format.xml { render xml: object, status: :created }
      else
        format.json { render json: object.errors, status: :unprocessable_entity }
        format.xml { render xml: object.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    object = get_model_class.new(get_model)
    respond_to do |format|
      if object.update_attributes(params[:user])
        format.json { head :no_content, status: :ok }
        format.xml { head :no_content, status: :ok }
      else
        format.json { render json: object.errors, status: :unprocessable_entity }
        format.xml { render xml: object.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    object = get_model_class.new(get_model)
    respond_to do |format|
      if object.destroy
        format.json { head :no_content, status: :ok }
        format.xml { head :no_content, status: :ok }
      else
        format.json { render json: object.errors, status: :unprocessable_entity }
        format.xml { render xml: object.errors, status: :unprocessable_entity }
      end
    end
  end
end
