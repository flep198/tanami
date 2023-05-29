ActiveAdmin.register Source do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :be1950name, :alt_name, :ra, :decl, :comment, :atca_link, :source_type, :redshift
  #
  # or
  #
  # permit_params do
  #   permitted = [:be1950name, :alt_name, :ra, :decl, :comment, :atca_link, :source_type, :redshift]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
