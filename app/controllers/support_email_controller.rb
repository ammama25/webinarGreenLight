

class SupportEmailController < ApplicationController
  include Verifier

  def create
    @user = User.find_by!(email: params[:email])
    puts("-----------------------------------------")
    puts(@user.name)
    puts("-----------------------------------------")

    begin

      @user.send_support_email(params[:support_email][:role], params[:support_email][:field], 
        params[:support_email][:desc])
    rescue => e
      logger.error "Error in email delivery: #{e}"
      flash[:alert] = I18n.t(params[:message], default: I18n.t("delivery_error"))
    else
      flash[:success] = I18n.t("email_sent", email_type: t("verify.verification"))
    end

    redirect_to(root_path)
  end

  private

  def email_params
    params.require(:email).permit(:email, :token)
    params.require(:support_email).permit(:role, :field, :desc)
  end

end
