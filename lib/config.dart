class Config {
  //adresse de l'api
  static String API = '192.168.43.4:5000';
  /**
   * Lien utilisé pour initialiser le traitement de la navigation vers un emplacement
   */
  static String SERVICESTARTWALKING = '/api/direction';
  /**
   * Lien utilisé pour effectuer le traitement nécessaire   pour guider l'utilisateur
   * lors de sa navigation 
   */
  static String SERVICESONWALKING = '/api/distancematrix';
  /**
   * Lien utilisé lors de l'arrivée de l'utilisateur à sa destination
   */
  static String SERVICEFINISHWALKING = '/api/finishwalking';
  /**
   * Lien utilisé pour trouver l'adresse de la destination choisie
   */
  static String SERVICEFINDDESTINATIONS = '/api/places/';
  /**
   * Lien utilisé pour connaitre la position actuelle de l'utilisateur
   */
  static String SERVICEWHEREAMI = '/api/geocodeRev';
  /**
   * L'adresse MAC du  connecteur BLUETOOTH
   */
  static String adresseBLE = "00:21:13:00:43:90";
}
