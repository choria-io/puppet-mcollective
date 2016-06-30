type Mcollective::Policy = Struct[{
  "action"  => Mcollective::Policy_action,
  "callers" => String,
  "actions" => String,
  "facts"   => String,
  "classes" => Optional[String]
}]
