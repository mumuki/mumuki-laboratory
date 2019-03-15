module VersionHelper
  def version_tags
    %Q{<script type="text/javascript">mumuki.version = '#{Mumuki::Laboratory::VERSION}';</script>}.html_safe
  end
end
