class DatasetsController < ApplicationController
  before_action :set_dataset, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /datasets or /datasets.json
  def index
    @datasets = Dataset.all
  end

  # GET /datasets/1 or /datasets/1.json
  def show
  end

  # GET /datasets/new
  def new
    @dataset = Dataset.new
  end

  # GET /datasets/1/edit
  def edit
  end

  def upload
  end

  def import
    #Use PyCall to import astropy.io.fits module
    fits=PyCall.import_module("astropy.io.fits")

    @data_files = params[:data_files]

    @data_files.each do |file|

      #open fits file and read header
      header=fits.open(file.path)[0].header
      
      #import general file info
      source_name=header["OBJECT"]
      epoch_id=header["OBSERVER"]
      obs_date=header["DATE-OBS"]

      #read out CVARs for RA, DECL and FREQ
      
        for a in 1..10 do
          begin
            keyword=header["CTYPE"+a.to_s]
            print(keyword)
            if keyword.include? "RA"
              ra=header["CRVAL"+a.to_s]
            elsif keyword.include? "DEC"
              decl=header["CRVAL"+a.to_s]
            elsif keyword.include? "FREQ"
              frequency=header["CRVAL"+a.to_s].to_f/1000000000
            end
          rescue
            #do nothing
          end
        end
      

      #read out image parameters if it is a .fits image file
      begin 
        beam_maj=header["BMAJ"]
        beam_min=header["BMIN"]
        beam_pos=header["BPA"]
        rms=header["NOISE"]
        peak_flux=header["DATAMAX"]
        filetype="fits"
      rescue
        filetype="uvf"
      end

      if not Source.exists?(be1950name: source_name)
        source=Source.create(:be1950name => source_name,:ra => ra, :decl => decl)
      else
        source_id=Source.where(be1950name: source_name).first.id
        Source.update(source_id, :ra => ra, :decl => decl)
      end
      session=Session.where(obs_code: epoch_id).first_or_create(data: obs_date)
      if not Band.exists?(freq: frequency-1.0..frequency+1.0)
        band=Band.create(:freq => frequency)
      else
        band=Band.where(freq: frequency-1.0..frequency+1.0).first
      end
      

      #creates new database entry only if the scan is not already in the database (to prevent double entries), otherwise old entry is overwritten
      if not Dataset.exists?(:source_id => source_id, :session_id => session.id, :band_id => band.id)
        if filetype=="uvf"
          @dataset=Dataset.create(:source_id => source_id, :session_id => session.id, :band_id => band.id)
          @dataset.uvf.attach(io: File.open(file.path), filename: source_name+"_"+epoch_id+".uvf")
        elsif filetype=="fits"
          @dataset=Dataset.create(:beam_maj => beam_maj, :beam_min => beam_min, :beam_pos => beam_pos, :peak_flux => peak_flux, :rms => rms, :source_id => source_id, :session_id => session.id, :band_id => band.id)
          @dataset.fits.attach(io: File.open(file.path), filename: source_name+"_"+epoch_id+".fits")
        end
      else #overwrite entry
        entry_id = Dataset.where(:source_id => source_id, :session_id => session.id, :band_id => band.id).first.id
        if filetype=="uvf" 
          Dataset.update(entry_id,:source_id => source_id, :session_id => session.id, :band_id => band.id)
          Dataset.find(entry_id).uvf.attach(io: File.open(file.path), filename: source_name+"_"+epoch_id+".uvf")
        elsif filetype=="fits"
          Dataset.update(entry_id, :beam_maj => beam_maj, :beam_min => beam_min, :beam_pos => beam_pos, :peak_flux => peak_flux, :rms => rms, :source_id => source_id, :session_id => session.id, :band_id => band.id)
          Dataset.find(entry_id).fits.attach(io: File.open(file.path), filename: source_name+"_"+epoch_id+".fits")
        end
      end
    end

    redirect_to datasets_path, notice: ("Data Uploaded Successfully")
  end

  # POST /datasets or /datasets.json
  def create
    @dataset = Dataset.new(dataset_params)

    respond_to do |format|
      if @dataset.save
        format.html { redirect_to dataset_url(@dataset), notice: "Dataset was successfully created." }
        format.json { render :show, status: :created, location: @dataset }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /datasets/1 or /datasets/1.json
  def update
    respond_to do |format|
      if @dataset.update(dataset_params)
        format.html { redirect_to dataset_url(@dataset), notice: "Dataset was successfully updated." }
        format.json { render :show, status: :ok, location: @dataset }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /datasets/1 or /datasets/1.json
  def destroy
    @dataset.destroy

    respond_to do |format|
      format.html { redirect_to datasets_url, notice: "Dataset was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dataset
      @dataset = Dataset.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def dataset_params
      params.require(:dataset).permit(:image, :uvf, :rms, :lowest_contour, :peak_flux, :beam_maj, :beam_min, :beam_pos, :session_id, :source_id, :band_id)
    end
end
