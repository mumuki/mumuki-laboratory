module WithReferer
  def from_sessions?
    params['controller'] == 'sessions'
  end
end
