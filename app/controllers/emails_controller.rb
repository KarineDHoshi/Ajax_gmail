require 'faker'

class EmailsController < ApplicationController
 
  def index
    @emails = Email.all
  end

  def new
    @new_email = Email.new
  end

  def create
    @email = Email.new("object" => Faker::FunnyName.name_with_initial,
                       "body" => Faker::GreekPhilosophers.name + 
                                 " a écrit : \"" + Faker::GreekPhilosophers.quote +
                                 "\" dans son oeuvre \"" + Faker::Lorem.characters(number: 15) + "\"")
    if @email.save # essaie de sauvegarder en base @email
      respond_to do |format|
        format.html { redirect_to root_path, status: :ok, notice: 'Tu as bien reçu un nouvel email !' }
        format.js { }
      end
      flash[:notice] = "Email created"
    else
      redirect_to root_path
      flash[:notice] = "Please try again"
    end
  end

  def edit
    @email = Email.find(params[:id])
  end
  
  def update
    @email = Email.find(params[:id])
    @email.update(email_params)
    redirect_to emails_path, status: :ok, notice: 'Ton email a bien été mis à jour en base !'
    flash[:notice] = "Email edited"
  end

  def destroy
    @email = get_email_hash
    @email['email'].destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { }
    end
  end

  def show
    @email = get_email_hash
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { }
    end
  end

  private
  
  def get_email_hash
    @email_hash = { "email" => nil, "index" => -1 }
    email_id = params[:id].to_i
    email = nil
    puts "$" * 60
    puts "email_id : #{email_id}"
    nb_total = Email.last.id
    if email_id.between?(1, nb_total)
      email = Email.find_by(id: email_id)
    end
    @email_hash = { "email" => email, "index" => email_id }
    puts "email_hash : #{@email_hash}"
    puts "$" * 60
    @email_hash
  end

  def email_params
    params.permit(:object, :body)
  end

end

