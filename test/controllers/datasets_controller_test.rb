require "test_helper"

class DatasetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dataset = datasets(:one)
  end

  test "should get index" do
    get datasets_url
    assert_response :success
  end

  test "should get new" do
    get new_dataset_url
    assert_response :success
  end

  test "should create dataset" do
    assert_difference('Dataset.count') do
      post datasets_url, params: { dataset: { beam_maj: @dataset.beam_maj, beam_min: @dataset.beam_min, beam_pos: @dataset.beam_pos, image: @dataset.image, lowest_contour: @dataset.lowest_contour, peak_flux: @dataset.peak_flux, rms: @dataset.rms, uvf: @dataset.uvf } }
    end

    assert_redirected_to dataset_url(Dataset.last)
  end

  test "should show dataset" do
    get dataset_url(@dataset)
    assert_response :success
  end

  test "should get edit" do
    get edit_dataset_url(@dataset)
    assert_response :success
  end

  test "should update dataset" do
    patch dataset_url(@dataset), params: { dataset: { beam_maj: @dataset.beam_maj, beam_min: @dataset.beam_min, beam_pos: @dataset.beam_pos, image: @dataset.image, lowest_contour: @dataset.lowest_contour, peak_flux: @dataset.peak_flux, rms: @dataset.rms, uvf: @dataset.uvf } }
    assert_redirected_to dataset_url(@dataset)
  end

  test "should destroy dataset" do
    assert_difference('Dataset.count', -1) do
      delete dataset_url(@dataset)
    end

    assert_redirected_to datasets_url
  end
end
