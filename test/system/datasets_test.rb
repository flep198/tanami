require "application_system_test_case"

class DatasetsTest < ApplicationSystemTestCase
  setup do
    @dataset = datasets(:one)
  end

  test "visiting the index" do
    visit datasets_url
    assert_selector "h1", text: "Datasets"
  end

  test "creating a Dataset" do
    visit datasets_url
    click_on "New Dataset"

    fill_in "Beam maj", with: @dataset.beam_maj
    fill_in "Beam min", with: @dataset.beam_min
    fill_in "Beam pos", with: @dataset.beam_pos
    fill_in "Image", with: @dataset.image
    fill_in "Lowest contour", with: @dataset.lowest_contour
    fill_in "Peak flux", with: @dataset.peak_flux
    fill_in "Rms", with: @dataset.rms
    fill_in "Uvf", with: @dataset.uvf
    click_on "Create Dataset"

    assert_text "Dataset was successfully created"
    click_on "Back"
  end

  test "updating a Dataset" do
    visit datasets_url
    click_on "Edit", match: :first

    fill_in "Beam maj", with: @dataset.beam_maj
    fill_in "Beam min", with: @dataset.beam_min
    fill_in "Beam pos", with: @dataset.beam_pos
    fill_in "Image", with: @dataset.image
    fill_in "Lowest contour", with: @dataset.lowest_contour
    fill_in "Peak flux", with: @dataset.peak_flux
    fill_in "Rms", with: @dataset.rms
    fill_in "Uvf", with: @dataset.uvf
    click_on "Update Dataset"

    assert_text "Dataset was successfully updated"
    click_on "Back"
  end

  test "destroying a Dataset" do
    visit datasets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dataset was successfully destroyed"
  end
end
