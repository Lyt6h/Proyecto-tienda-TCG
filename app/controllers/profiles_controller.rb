class ProfilesController < ApplicationController
  def show
    @user = Current.user
  end

  def update
    @user = Current.user
    if @user.update(profile_params)
      redirect_to profile_path, notice: t("profiles.update_success")
    else
      puts "ERRORES DE VALIDACIÓN: #{@user.errors.full_messages}"
      render :show, status: :unprocessable_entity
    end
  end

  private

    def profile_params
      params.require(:user).permit(:profile_picture, :full_name, :phone_number, :street, :number, :apartment, :district,
                                   :city)
    end
end
