class LabelsController < ApplicationController
  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.build(label_params)
    if @label.save
      redirect_to labels_path, notice: "ラベルを登録しました"
    else
      render :new, notice: "ラベル登録のエラーです"
    end
  end

  def index
  end

  def edit
  end

  private
  def label_params
    params.require(:label).permit(:name)
  end
end
