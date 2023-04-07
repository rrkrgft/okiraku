class LabelsController < ApplicationController
  before_action :authenticate_user!

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
    @labels = current_user.labels
  end

  def edit
    set_label
  end

  def update
    set_label
    if @label.update(label_params)
      redirect_to labels_path, notice: "ラベルを編集しました"
    else
      render :edit, notice: "ラベルの編集エラーです"
    end
  end

  def destroy
    set_label
    @label.destroy
    redirect_to labels_path, notice: "ラベルを削除しました"
  end

  private
  def label_params
    params.require(:label).permit(:name)
  end

  def set_label
    @label = current_user.labels.find(params[:id])
  end
end
