module ApplicationHelper

  def cell_style(f)
    str = "background-color: #{risk_background(f)}; color: #{risk_text_color(f)};"
    str << "border: 4px solid red;" if f.risk_level == 'likely'
    str
  end

  def risk_level_style(f)
    """
      background-color: #{risk_background(f)};
      color: #{risk_text_color(f)};
      border: #{header_border_size(f)} solid #{risk_color(f)};
    """
  end

  def header_style(f)
    str = "color: #{header_text_color(f)};"
    str << "border-top: #{header_border_size(f)} solid #{risk_color(f)};"
    str << "background-color: #{risk_background(f)};"
    str
  end

  private

  def header_border_size(f)
    f.today? ? '5px' : '3px'
  end

  def risk_background(f)
    'red' if f.risk_level == 'likely'
  end

  def risk_text_color(f)
    'white' if f.risk_level == 'likely'
  end

  def risk_color(f)
    case f.risk_level
    when 'likely'   then 'red'
    when 'possible' then 'orange'
    when 'unlikely' then 'green'
    end
  end

  def header_text_color(f)
    f.risk_level == 'likely' ? 'white' : '#777'
  end

end
