describe 'Cloud Servers', :markdown =>
  """
  
  Scenarios using [Next Generation Cloud Servers API V2](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ch_preface.html).
  """ do
    code_sample "Create Server", """
    [Create a Server](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/CreateServers.html)
    using the image and flavor, and region specified in the environment.
    """, standard_env_vars.merge({
      'RAX_REGION' => 'DFW',
      'SERVER1_IMAGE' => 'f70ed7c7-b42e-4d77-83d8-40fa29825b85',
      'SERVER1_FLAVOR' => 'performance1-1'
    }),  [] do |success|
      # Assertions
      expect(Pacto).to have_validated_service('Cloud Servers', 'Create Server')
      expect(Pacto).to_not have_failed_validations
      expect(Pacto).to_not have_unmatched_requests
  end
end
