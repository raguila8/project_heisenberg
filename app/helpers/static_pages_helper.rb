module StaticPagesHelper
  def landing_page_button(value, path, section)
    button_to value, 
              path,
              method: :get, 
              class: 'btn g-mt-10 g-mb-10 
                     g-rounded-20 g-pv-12 g-btn-landing',
              id: "btn-#{section}"
  end

  def puts_landing_page_home_button
    if signed_in?
      landing_page_button 'SOLVE NOW!', dashboard_path, 'home'
    else
      landing_page_button 'START NOW FREE', signup_path, 'home' 
    end
  end

  def puts_landing_page_cta_button
    if signed_in?
      landing_page_button 'Start Solving!', dashboard_path, 'cta'
    else
      landing_page_button "Let's Get Started", signup_path, 'cta'
    end
  end

  
end
