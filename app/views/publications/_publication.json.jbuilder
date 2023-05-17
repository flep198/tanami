json.extract! publication, :id, :authors, :title, :reference, :ads_link, :arxiv_link, :pdf_link, :created_at, :updated_at
json.url publication_url(publication, format: :json)
