class TrainingsController < ApplicationController
  # GET /trainings
  # GET /trainings.xml
  def index
    @trainings = Training.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trainings }
    end
  end

  # GET /trainings/1
  # GET /trainings/1.xml
  def show
    @training = Training.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @training }
    end
  end

  # GET /trainings/new
  # GET /trainings/new.xml
  def new
    @training = Training.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @training }
    end
  end

  # GET /trainings/1/edit
  def edit
    @training = Training.find(params[:id])
  end

  # POST /trainings
  # POST /trainings.xml
  def create
    @training = Training.new(params[:training])

    respond_to do |format|
      if @training.save
        flash[:notice] = 'Training was successfully created.'
        format.html { redirect_to(:action=>:index) }
        format.xml  { render :xml => @training, :status => :created, :location => @training }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @training.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trainings/1
  # PUT /trainings/1.xml
  def update
    @training = Training.find(params[:id])

    respond_to do |format|
      if @training.update_attributes(params[:training])
        flash[:notice] = 'Training was successfully updated.'
        format.html { redirect_to(@training) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @training.errors, :status => :unprocessable_entity }
      end
    end
  end

end
