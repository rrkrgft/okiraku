require "test_helper"

class LabelsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get labels_new_url
    assert_response :success
  end

  test "should get index" do
    get labels_index_url
    assert_response :success
  end

  test "should get edit" do
    get labels_edit_url
    assert_response :success
  end
end
