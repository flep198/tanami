ActiveAdmin.register Publication do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :authors, :title, :reference, :ads_link, :arxiv_link, :pdf_link
  #
  # or
  #
  # permit_params do
  #   permitted = [:authors, :title, :reference, :ads_link, :arxiv_link, :pdf_link]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
