class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]
  
  def index
    @movies = Movie.all
    sort_var_one = 'title'
    sort_var_two = 'release_date'
    @all_ratings = @include_ratings = Movie.unique_ratings
    
    if !params[:sort_par].nil?
      session[:sort_par] = params[:sort_par]
      @movies = !session[:ratings].nil? ? Movie.with_ratings(session[:ratings].keys).order(params[:sort_par]) \
                : Movie.all.order(params[:sort_par])
      @title_head_hi = 'hilite' if params[:sort_par] == sort_var_one
      @release_date_hi = 'hilite' if params[:sort_par] == sort_var_two
    elsif !params[:ratings].nil?
      session[:ratings] = params[:ratings]
      @movies = !session[:sort_par].nil? ? Movie.with_ratings(params[:ratings].keys).order(session[:sort_par]) \
                : Movie.with_ratings(params[:ratings].keys)
      @title_head_hi = 'hilite' if session[:sort_par] == sort_var_one
      @release_date_hi = 'hilite' if session[:sort_par] == sort_var_two
    
    elsif !session[:sort_par].nil? and !session[:ratings].nil?
      @movies = Movie.with_ratings(session[:ratings].keys).order(session[:sort_par])
      @title_head_hi = 'hilite' if session[:sort_par] == sort_var_one
      @release_date_hi = 'hilite' if session[:sort_par] == sort_var_two
    elsif session[:sort_par].nil? and session[:ratings].nil?
      @movies = Movie.all
    else
      @movies = !session[:sort_par].nil? ? Movie.all.order(session[:sort_par]) : Movie.with_ratings(session[:ratings].keys)
      @title_head_hi = 'hilite' if session[:sort_par] == sort_var_one
      @release_date_hi = 'hilite' if session[:sort_par] == sort_var_two
    
    end
    @include_ratings = session[:ratings].keys if !session[:ratings].nil?
  end
  
  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end
