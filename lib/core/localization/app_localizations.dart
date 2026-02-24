import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';

class AppLocalizations {
  final AppLanguage language;

  AppLocalizations(this.language);

  static final Map<String, Map<AppLanguage, String>> _localizedValues = {
    // --- Onboarding ---
    'welcome_title': {
      AppLanguage.english: 'Welcome to\nOpinion Bluff',
      AppLanguage.french: 'Bienvenue sur\nOpinion Bluff',
      AppLanguage.spanish: 'Bienvenido a\nOpinion Bluff',
    },
    'welcome_tagline': {
      AppLanguage.english: 'Everything you need for your next\nparty night all in one place.',
      AppLanguage.french: 'Tout ce dont vous avez besoin pour votre prochaine\nsoirée de fête en un seul endroit.',
      AppLanguage.spanish: 'Todo lo que necesitas para tu próxima\nnoche de fiesta en un solo lugar.',
    },
    'continue': {AppLanguage.english: 'Continue', AppLanguage.french: 'Continuer', AppLanguage.spanish: 'Continuar'},
    'back': {AppLanguage.english: 'Back', AppLanguage.french: 'Retour', AppLanguage.spanish: 'Atrás'},
    'quit': {AppLanguage.english: 'Quit', AppLanguage.french: 'Quitter', AppLanguage.spanish: 'Salir'},
    'quit_confirm_title': {
      AppLanguage.english: 'Quit Game?',
      AppLanguage.french: 'Quitter le jeu ?',
      AppLanguage.spanish: '¿Salir del juego?',
    },
    'quit_confirm_message': {
      AppLanguage.english: 'Are you sure you want to quit? Your current progress will be lost.',
      AppLanguage.french: 'Êtes-vous sûr de vouloir quitter ? Votre progression actuelle sera perdue.',
      AppLanguage.spanish: '¿Estás seguro de que quieres salir? Tu progreso actual se perderá.',
    },
    'confirm_quit': {AppLanguage.english: 'Quit', AppLanguage.french: 'Quitter', AppLanguage.spanish: 'Salir'},
    'who_play_with': {
      AppLanguage.english: 'Who do you most like\nto play with?',
      AppLanguage.french: 'Avec qui aimez-vous\nle plus jouer ?',
      AppLanguage.spanish: '¿Con quién te gusta\nmás jugar?',
    },
    'friends': {AppLanguage.english: 'Friends', AppLanguage.french: 'Amis', AppLanguage.spanish: 'Amigos'},
    'family': {AppLanguage.english: 'Family', AppLanguage.french: 'Famille', AppLanguage.spanish: 'Familia'},
    'partner': {AppLanguage.english: 'Partner', AppLanguage.french: 'Partenaire', AppLanguage.spanish: 'Pareja'},
    'colleagues': {AppLanguage.english: 'Colleagues', AppLanguage.french: 'Collègues', AppLanguage.spanish: 'Colegas'},
    'driver_instruction': {
      AppLanguage.english: 'For the best game experience, tell the driver.',
      AppLanguage.french: 'Pour la meilleure expérience de jeu, informez le meneur.',
      AppLanguage.spanish: 'Para la mejor experiencia de juego, infórmale al conductor.',
    },
    'who_is_playing': {
      AppLanguage.english: 'Who is Playing?',
      AppLanguage.french: 'Qui joue ?',
      AppLanguage.spanish: '¿Quién está jugando?',
    },
    'male': {AppLanguage.english: 'Male', AppLanguage.french: 'Homme', AppLanguage.spanish: 'Masculino'},
    'female': {AppLanguage.english: 'Female', AppLanguage.french: 'Femme', AppLanguage.spanish: 'Femenino'},
    'choose_avatar_source': {
      AppLanguage.english: 'Change Avatar',
      AppLanguage.french: 'Changer l\'avatar',
      AppLanguage.spanish: 'Cambiar avatar',
    },
    'choose_from_gallery': {
      AppLanguage.english: 'Choose from Gallery',
      AppLanguage.french: 'Choisir dans la galerie',
      AppLanguage.spanish: 'Elegir de la galería',
    },
    'take_photo': {
      AppLanguage.english: 'Take Photo',
      AppLanguage.french: 'Prendre une photo',
      AppLanguage.spanish: 'Tomar foto',
    },
    'add_players_hint': {
      AppLanguage.english: 'Add at least 3 players to start.',
      AppLanguage.french: 'Ajoutez au moins 3 joueurs pour commencer.',
      AppLanguage.spanish: 'Añade al menos 3 jugadores para empezar.',
    },
    'enter_name': {
      AppLanguage.english: 'Enter name...',
      AppLanguage.french: 'Entrez le nom...',
      AppLanguage.spanish: 'Introduce el nombre...',
    },
    'choose_punishment': {
      AppLanguage.english: 'Choose Punishment',
      AppLanguage.french: 'Choisissez une punition',
      AppLanguage.spanish: 'Elige un castigo',
    },
    'bluffer_instruction': {
      AppLanguage.english: 'The Bluffer must do this if they get caught!',
      AppLanguage.french: 'Le Bluffeur doit le faire s\'il se fait prendre !',
      AppLanguage.spanish: '¡El Mentiroso debe hacer esto si es atrapado!',
    },
    'all_names_required': {
      AppLanguage.english: 'All player names are required',
      AppLanguage.french: 'Tous les noms de joueurs sont requis',
      AppLanguage.spanish: 'Todos los nombres de los jugadores son obligatorios',
    },
    'how_many_players': {
      AppLanguage.english: 'How many players?',
      AppLanguage.french: 'Combien de joueurs?',
      AppLanguage.spanish: '¿Cuántos jugadores?',
    },
    'player_count_title': {
      AppLanguage.english: 'Players',
      AppLanguage.french: 'Joueurs',
      AppLanguage.spanish: 'Jugadores',
    },
    'player_names_title': {AppLanguage.english: 'Names', AppLanguage.french: 'Noms', AppLanguage.spanish: 'Nombres'},
    'topic_mode_title': {
      AppLanguage.english: 'Topic Mode',
      AppLanguage.french: 'Mode de sujet',
      AppLanguage.spanish: 'Modo de tema',
    },
    'enter_player_names_instr': {
      AppLanguage.english: 'Please enter player {i}',
      AppLanguage.french: 'Veuillez entrer le joueur {i}',
      AppLanguage.spanish: 'Por favor, introduce el jugador {i}',
    },
    'choose_topic_mode': {
      AppLanguage.english: 'Choose Topic Mode',
      AppLanguage.french: 'Choisir le mode de sujet',
      AppLanguage.spanish: 'Elegir modo de tema',
    },
    'topic_mode_desc': {
      AppLanguage.english: 'Same: Everyone sees the same topic.\nMixed: Everyone sees a different topic.',
      AppLanguage.french: 'Identique: Tout le monde voit le même sujet.\nMixte: Tout le monde voit un sujet différent.',
      AppLanguage.spanish: 'Igual: Todos ven el mismo tema.\nMixto: Todos ven un tema diferente.',
    },
    'add_custom_punishment': {
      AppLanguage.english: '+ Add Custom Punishment',
      AppLanguage.french: '+ Ajouter une punition personnalisée',
      AppLanguage.spanish: '+ Añadir castigo personalizado',
    },
    'punishment_pushups': {
      AppLanguage.english: 'Do 10 push-ups',
      AppLanguage.french: 'Fais 10 pompes',
      AppLanguage.spanish: 'Haz 10 flexiones',
    },
    'punishment_dinner': {
      AppLanguage.english: 'Pay for dinner',
      AppLanguage.french: 'Paye le dîner',
      AppLanguage.spanish: 'Paga la cena',
    },
    'punishment_prank': {
      AppLanguage.english: 'Call your mom or dad and prank them',
      AppLanguage.french: 'Appelle tes parents pour leur faire une blague',
      AppLanguage.spanish: 'Llama a tus padres y gastales una broma',
    },
    'punishment_sing': {
      AppLanguage.english: 'Sing a song',
      AppLanguage.french: 'Chante une chanson',
      AppLanguage.spanish: 'Canta una canción',
    },
    'punishment_dance': {
      AppLanguage.english: 'Dance for 30 seconds',
      AppLanguage.french: 'Danse pendant 30 secondes',
      AppLanguage.spanish: 'Baila durante 30 segundos',
    },
    'type_punishment_here': {
      AppLanguage.english: 'Type punishment here...',
      AppLanguage.french: 'Tapez la punition ici...',
      AppLanguage.spanish: 'Escribe el castigo aquí...',
    },
    'add': {AppLanguage.english: 'Add', AppLanguage.french: 'Ajouter', AppLanguage.spanish: 'Añadir'},
    'cancel': {AppLanguage.english: 'Cancel', AppLanguage.french: 'Annuler', AppLanguage.spanish: 'Cancelar'},
    'how_to_play': {
      AppLanguage.english: 'How To Play',
      AppLanguage.french: 'Comment jouer',
      AppLanguage.spanish: 'Cómo jugar',
    },
    'got_it': {AppLanguage.english: 'Got It', AppLanguage.french: 'Compris', AppLanguage.spanish: 'Lo tengo'},
    'unlock_everything_title': {
      AppLanguage.english: 'Unlock everything!',
      AppLanguage.french: 'Tout débloquer !',
      AppLanguage.spanish: '¡Desbloquéalo todo!',
    },
    'unlock_everything_desc': {
      AppLanguage.english: 'All packs, custom topics, no ads & more.',
      AppLanguage.french: 'Packs, sujets perso, sans pub & plus.',
      AppLanguage.spanish: 'Packs, temas propios, sin anuncios y más.',
    },
    'next': {AppLanguage.english: 'Next', AppLanguage.french: 'Suivant', AppLanguage.spanish: 'Siguiente'},
    'start_game': {AppLanguage.english: 'Start Game', AppLanguage.french: 'Commencer', AppLanguage.spanish: 'Empezar'},

    // --- Setup / Home ---
    'game': {AppLanguage.english: 'Game', AppLanguage.french: 'Jeu', AppLanguage.spanish: 'Juego'},
    'settings': {AppLanguage.english: 'Settings', AppLanguage.french: 'Paramètres', AppLanguage.spanish: 'Ajustes'},
    'language': {AppLanguage.english: 'Language', AppLanguage.french: 'Langue', AppLanguage.spanish: 'Idioma'},
    'change': {AppLanguage.english: 'Change', AppLanguage.french: 'Modifier', AppLanguage.spanish: 'Cambiar'},
    'punishments': {
      AppLanguage.english: 'Punishments',
      AppLanguage.french: 'Punitions',
      AppLanguage.spanish: 'Castigos',
    },
    'sound_controls': {
      AppLanguage.english: 'Sound Controls',
      AppLanguage.french: 'Commandes sonores',
      AppLanguage.spanish: 'Controles de sonido',
    },
    'sound_effects': {
      AppLanguage.english: 'Sound Effects',
      AppLanguage.french: 'Effets sonores',
      AppLanguage.spanish: 'Efectos de sonido',
    },
    'haptics': {AppLanguage.english: 'Haptics', AppLanguage.french: 'Haptique', AppLanguage.spanish: 'Hápticos'},
    'duration': {AppLanguage.english: 'Duration', AppLanguage.french: 'Durée', AppLanguage.spanish: 'Duración'},
    'same_topic': {
      AppLanguage.english: 'Same Topic',
      AppLanguage.french: 'Même sujet',
      AppLanguage.spanish: 'Mismo tema',
    },
    'mixed_topic': {
      AppLanguage.english: 'Mixed Topic',
      AppLanguage.french: 'Sujet mixte',
      AppLanguage.spanish: 'Tema mixto',
    },
    'topics_related_to': {
      AppLanguage.english: 'Topics Related to:',
      AppLanguage.french: 'Sujets liés à :',
      AppLanguage.spanish: 'Temas relacionados con:',
    },
    'player_names': {
      AppLanguage.english: 'Player Names',
      AppLanguage.french: 'Noms des joueurs',
      AppLanguage.spanish: 'Nombres de los jugadores',
    },
    'topic_mode': {
      AppLanguage.english: 'Topic Mode',
      AppLanguage.french: 'Mode de sujet',
      AppLanguage.spanish: 'Modo de tema',
    },
    'subscription_rewards': {
      AppLanguage.english: 'Membership Rewards',
      AppLanguage.french: 'Récompenses d\'adhésion',
      AppLanguage.spanish: 'Recompensas de membresía',
    },
    'dismiss': {AppLanguage.english: 'Dismiss', AppLanguage.french: 'Ignorer', AppLanguage.spanish: 'Descartar'},
    'worldwide_tagline': {
      AppLanguage.english: '#1 Party App Worldwide',
      AppLanguage.french: 'L\'app n°1 pour faire la fête',
      AppLanguage.spanish: 'La app n°1 para fiestas',
    },
    'invite_friends': {
      AppLanguage.english: 'Invite Friends',
      AppLanguage.french: 'Inviter des amis',
      AppLanguage.spanish: 'Invitar amigos',
    },
    'rating_text': {
      AppLanguage.english: ' 5.0 Rating',
      AppLanguage.french: ' Note : 5.0',
      AppLanguage.spanish: ' 5.0 Valoración',
    },

    // --- Game Screens ---
    'reveal_phase': {
      AppLanguage.english: 'Reveal Phase',
      AppLanguage.french: 'Phase de révélation',
      AppLanguage.spanish: 'Fase de revelación',
    },
    'discussion_phase': {
      AppLanguage.english: 'Discussion Phase',
      AppLanguage.french: 'Phase de discussion',
      AppLanguage.spanish: 'Fase de discusión',
    },
    'voting_phase': {
      AppLanguage.english: 'Voting Phase',
      AppLanguage.french: 'Phase de vote',
      AppLanguage.spanish: 'Fase de votación',
    },
    'result_page': {AppLanguage.english: 'Results', AppLanguage.french: 'Résultats', AppLanguage.spanish: 'Resultados'},
    'show_votes': {
      AppLanguage.english: 'Show Votes',
      AppLanguage.french: 'Voir les votes',
      AppLanguage.spanish: 'Ver votos',
    },
    'winner': {AppLanguage.english: 'Winner!', AppLanguage.french: 'Gagnant !', AppLanguage.spanish: '¡Ganador!'},
    'bluffer_won': {
      AppLanguage.english: 'The Bluffer Escaped!',
      AppLanguage.french: 'Le Bluffeur s\'est échappé !',
      AppLanguage.spanish: '¡El Mentiroso escapó!',
    },
    'group_won': {
      AppLanguage.english: 'The Group Caught the Bluffer!',
      AppLanguage.french: 'Le Groupe a attrapé le Bluffeur !',
      AppLanguage.spanish: '¡El Grupo atrapó al Mentiroso!',
    },

    // --- Dialogs & Errors ---
    // (Keys moved to Setup section)
    // --- How To Play ---
    'htp_overview_title': {
      AppLanguage.english: 'Game Overview',
      AppLanguage.french: 'Aperçu du jeu',
      AppLanguage.spanish: 'Descripción del juego',
    },
    'htp_overview_desc': {
      AppLanguage.english:
          'Opinion Bluff is a social game of deception and debate. One player is the Bluffer while the others are the Honest group.',
      AppLanguage.french:
          'Opinion Bluff est un jeu social de tromperie et de débat. Un joueur est le Bluffeur tandis que les autres sont le groupe Honnête.',
      AppLanguage.spanish:
          'Opinion Bluff es un juego social de engaño y debate. Un jugador es el Mentiroso mientras que los otros son el grupo Honesto.',
    },
    'htp_overview_detail': {
      AppLanguage.english:
          'The goal of the group is to find the Bluffer. The goal of the Bluffer is to blend in and not get caught.',
      AppLanguage.french:
          'Le but du groupe est de trouver le Bluffeur. Le but du Bluffeur est de se fondre dans la masse et de ne pas se faire prendre.',
      AppLanguage.spanish:
          'El objetivo del grupo es encontrar al Mentiroso. El objetivo del Mentiroso es mezclarse y no ser atrapado.',
    },
    'htp_reveal_title': {
      AppLanguage.english: 'Reveal Phase',
      AppLanguage.french: 'Phase de révélation',
      AppLanguage.spanish: 'Fase de revelación',
    },
    'htp_reveal_desc': {
      AppLanguage.english: 'Pass the phone around. Each player holds their card to reveal their secret topic.',
      AppLanguage.french: 'Faites circuler le téléphone. Chaque joueur tient sa carte pour révéler son sujet secret.',
      AppLanguage.spanish: 'Pasa el teléfono. Cada jugador sostiene su tarjeta para revelar su tema secreto.',
    },
    'htp_reveal_detail': {
      AppLanguage.english:
          'Keep your screen hidden! If you are the Bluffer, you won\'t know the group\'s topic, but you will get a fake one.',
      AppLanguage.french:
          'Gardez votre écran caché ! Si vous êtes le Bluffeur, vous ne connaîtrez pas le sujet du groupe, mais vous en recevrez un faux.',
      AppLanguage.spanish:
          '¡Mantén tu pantalla oculta! Si eres el Mentiroso, no sabrás el tema del groupe, sino que recibirás uno falso.',
    },
    'htp_discussion_title': {
      AppLanguage.english: 'Discussion Phase',
      AppLanguage.french: 'Phase de discussion',
      AppLanguage.spanish: 'Fase de discusión',
    },
    'htp_discussion_desc': {
      AppLanguage.english: 'Start the timer and talk! Defend your opinion and discuss the topic with others.',
      AppLanguage.french: 'Lancez le minuteur et parlez ! Défendez votre opinion et discutez du sujet avec les autres.',
      AppLanguage.spanish: '¡Inicia el cronómetro y habla! Defiende tu opinión y discute el tema con los demás.',
    },
    'htp_discussion_detail': {
      AppLanguage.english:
          'Listen carefully. The Bluffer will try to sound like they know what they are talking about, even if they don\'t!',
      AppLanguage.french:
          'Écoutez attentivement. Le Bluffeur essaiera de donner l\'impression qu\'il sait de quoi il parle, même si ce n\'est pas le cas !',
      AppLanguage.spanish:
          'Escucha atentamente. ¡El Mentiroso intentará sonar como si supiera de lo que está hablando, incluso si no es así!',
    },
    'htp_voting_title': {
      AppLanguage.english: 'Voting Phase',
      AppLanguage.french: 'Phase de vote',
      AppLanguage.spanish: 'Fase de votación',
    },
    'htp_voting_desc': {
      AppLanguage.english: 'Once the time is up, everyone votes secretly for who they think is the Bluffer.',
      AppLanguage.french:
          'Une fois le temps écoulé, tout le monde vote secrètement pour celui qu\'il pense être le Bluffeur.',
      AppLanguage.spanish:
          'Una vez que se acabe el tiempo, todos votan en secreto por quién creen que es el Mentiroso.',
    },
    'htp_voting_detail': {
      AppLanguage.english:
          'If the majority catches the Bluffer, the group wins! Otherwise, the Bluffer escapes and wins.',
      AppLanguage.french:
          'Si la majorité attrape le Bluffeur, le groupe gagne ! Sinon, le Bluffeur s\'échappe et gagne.',
      AppLanguage.spanish:
          'Si la mayoría atrapa al Mentiroso, ¡el grupo gana! De lo contrario, el Mentiroso escapa y gana.',
    },
    // --- Reveal Screen ---
    'revealed_release_hide': {
      AppLanguage.english: 'Revealed! Release to hide.',
      AppLanguage.french: 'Révélé ! Relâchez pour masquer.',
      AppLanguage.spanish: '¡Revelado! Suelta para ocultar.',
    },
    'hold_to_reveal': {
      AppLanguage.english: 'Hold at the top to reveal your topic.',
      AppLanguage.french: 'Maintenez en haut pour révéler votre sujet.',
      AppLanguage.spanish: 'Mantén presionado arriba para revelar tu tema.',
    },
    'next_player': {
      AppLanguage.english: 'Next Player',
      AppLanguage.french: 'Joueur suivant',
      AppLanguage.spanish: 'Siguiente jugador',
    },
    'start_discussion': {
      AppLanguage.english: 'Start Discussion',
      AppLanguage.french: 'Lancer la discussion',
      AppLanguage.spanish: 'Iniciar discusión',
    },
    'revealing': {
      AppLanguage.english: 'REVEALING...',
      AppLanguage.french: 'RÉVÉLATION...',
      AppLanguage.spanish: 'REVELANDO...',
    },
    'locked': {AppLanguage.english: 'LOCKED', AppLanguage.french: 'VERROUILLÉ', AppLanguage.spanish: 'BLOQUEADO'},
    'secret_topic_label': {
      AppLanguage.english: 'SECRET TOPIC:',
      AppLanguage.french: 'SUJET SECRET :',
      AppLanguage.spanish: 'TEMA SECRETO:',
    },
    'bluff_instruction_short': {
      AppLanguage.english: 'BLUFF: Defend this strictly.',
      AppLanguage.french: 'BLUFF : Défendez-le strictement.',
      AppLanguage.spanish: 'BLUFF: Defiende esto estrictamente.',
    },
    'hold_at_top': {
      AppLanguage.english: 'Hold at top',
      AppLanguage.french: 'Maintenez en haut',
      AppLanguage.spanish: 'Mantén arriba',
    },
    // --- Discussion Screen ---
    'discussion_title': {
      AppLanguage.english: 'Discussion',
      AppLanguage.french: 'Discussion',
      AppLanguage.spanish: 'Discusión',
    },
    'defend_opinion_tagline': {
      AppLanguage.english: 'Defend your opinion!',
      AppLanguage.french: 'Défendez votre opinion !',
      AppLanguage.spanish: '¡Defiende tu opinión!',
    },
    'proceed_to_voting': {
      AppLanguage.english: 'Proceed to Voting',
      AppLanguage.french: 'Passer au vote',
      AppLanguage.spanish: 'Proceder a la votación',
    },
    'skip': {AppLanguage.english: 'Skip', AppLanguage.french: 'Passer', AppLanguage.spanish: 'Saltar'},
    'waiting': {AppLanguage.english: 'Waiting', AppLanguage.french: 'En attente', AppLanguage.spanish: 'Esperando'},
    'discussing': {
      AppLanguage.english: 'Discussing',
      AppLanguage.french: 'En discussion',
      AppLanguage.spanish: 'Discutiendo',
    },
    'completed': {AppLanguage.english: 'Completed', AppLanguage.french: 'Terminé', AppLanguage.spanish: 'Completado'},
    // --- Voting Screen ---
    'pass_phone_to': {
      AppLanguage.english: 'Pass the phone to',
      AppLanguage.french: 'Passez le téléphone à',
      AppLanguage.spanish: 'Pasa el téléphone a',
    },
    'player_vote_title': {
      AppLanguage.english: '{name}\'s Vote',
      AppLanguage.french: 'Vote de {name}',
      AppLanguage.spanish: 'Voto de {name}',
    },
    'who_is_bluffer': {
      AppLanguage.english: 'Who is the Bluffer?',
      AppLanguage.french: 'Qui est le Bluffeur ?',
      AppLanguage.spanish: '¿Quién es el Mentiroso?',
    },
    'confirm_vote': {
      AppLanguage.english: 'Confirm Vote',
      AppLanguage.french: 'Confirmer le vote',
      AppLanguage.spanish: 'Confirmar voto',
    },
    'show_results': {
      AppLanguage.english: 'Show Results',
      AppLanguage.french: 'Voir les résultats',
      AppLanguage.spanish: 'Ver resultados',
    },
    // --- Result Screen ---
    'group_wins': {
      AppLanguage.english: 'Group Wins!',
      AppLanguage.french: 'Le groupe gagne !',
      AppLanguage.spanish: '¡El grupo gana!',
    },
    'bluffer_wins': {
      AppLanguage.english: 'Bluffer Wins!',
      AppLanguage.french: 'Le Bluffeur gagne !',
      AppLanguage.spanish: '¡El Mentiroso gana!',
    },
    'bluffer_caught_desc': {
      AppLanguage.english: 'The Bluffer was caught.',
      AppLanguage.french: 'Le Bluffeur a été démasqué.',
      AppLanguage.spanish: 'El Mentiroso fue atrapado.',
    },
    'bluffer_convincing_desc': {
      AppLanguage.english: 'The Bluffer was too convincing.',
      AppLanguage.french: 'Le Bluffeur était trop convaincant.',
      AppLanguage.spanish: 'El Mentiroso fue demasiado convincente.',
    },
    'the_punishment_label': {
      AppLanguage.english: 'THE PUNISHMENT',
      AppLanguage.french: 'LA PUNITION',
      AppLanguage.spanish: 'EL CASTIGO',
    },
    'bluffer_pay_price': {
      AppLanguage.english: 'The Bluffer must pay the price!',
      AppLanguage.french: 'Le Bluffeur doit payer le prix !',
      AppLanguage.spanish: '¡El Mentiroso debe pagar el precio!',
    },
    'group_pay_price': {
      AppLanguage.english: 'The Group must pay the price!',
      AppLanguage.french: 'Le groupe doit payer le prix !',
      AppLanguage.spanish: '¡El grupo debe pagar el precio!',
    },
    'hide_vote_details': {
      AppLanguage.english: 'Hide Vote Details',
      AppLanguage.french: 'Masquer les détails du vote',
      AppLanguage.spanish: 'Ocultar detalles del voto',
    },
    'show_vote_details': {
      AppLanguage.english: 'Show Vote Details',
      AppLanguage.french: 'Voir les détails du vote',
      AppLanguage.spanish: 'Ver detalles del voto',
    },
    'player_table_header': {
      AppLanguage.english: 'Player',
      AppLanguage.french: 'Joueur',
      AppLanguage.spanish: 'Jugador',
    },
    'voted_for_table_header': {
      AppLanguage.english: 'Voted For',
      AppLanguage.french: 'A voté pour',
      AppLanguage.spanish: 'Votó por',
    },
    'result_table_header': {
      AppLanguage.english: 'Result',
      AppLanguage.french: 'Résultat',
      AppLanguage.spanish: 'Resultado',
    },
    'correct_vote': {AppLanguage.english: 'Correct', AppLanguage.french: 'Correct', AppLanguage.spanish: 'Correcto'},
    'wrong_vote': {AppLanguage.english: 'Wrong', AppLanguage.french: 'Faux', AppLanguage.spanish: 'Incorrecto'},
    'back_to_lobby': {
      AppLanguage.english: 'Back to Lobby',
      AppLanguage.french: 'Retour au salon',
      AppLanguage.spanish: 'Volver al lobby',
    },
    // --- Topics Screen ---
    'select_packs': {
      AppLanguage.english: 'Select Packs',
      AppLanguage.french: 'Choisir les packs',
      AppLanguage.spanish: 'Seleccionar packs',
    },
    'select_packs_desc': {
      AppLanguage.english: 'More packs, more chaos — pick your favorites!',
      AppLanguage.french: 'Plus de packs, plus de chaos — choisissez vos favoris !',
      AppLanguage.spanish: '¡Más packs, más caos — elige tus favoritos!',
    },
    'create': {AppLanguage.english: 'Create', AppLanguage.french: 'Créer', AppLanguage.spanish: 'Crear'},
    'updated': {AppLanguage.english: 'Updated', AppLanguage.french: 'Modifié', AppLanguage.spanish: 'Actualizado'},
    'unlock_all_packs': {
      AppLanguage.english: 'Unlock All Packs',
      AppLanguage.french: 'Débloquer tous les packs',
      AppLanguage.spanish: 'Desbloquear todos los packs',
    },
    'unlock_packs_desc': {
      AppLanguage.english: 'Access every topic pack and remove restrictions.',
      AppLanguage.french: 'Accédez à tous les packs de sujets et levez les restrictions.',
      AppLanguage.spanish: 'Accede a todos los packs de temas y elimina las restricciones.',
    },
    'start_free_trial': {
      AppLanguage.english: 'Start Free Trial',
      AppLanguage.french: 'Commencer l\'essai gratuit',
      AppLanguage.spanish: 'Comenzar prueba gratuita',
    },
    'trial_desc': {
      AppLanguage.english: '3 days free, then annual subscription',
      AppLanguage.french: '3 jours gratuits, puis abonnement annuel',
      AppLanguage.spanish: '3 días gratis, luego suscripción anual',
    },

    'restore_purchase': {
      AppLanguage.english: 'Restore Purchase',
      AppLanguage.french: 'Restaurer l\'achat',
      AppLanguage.spanish: 'Restaurar compra',
    },
    'mystery_pack': {
      AppLanguage.english: 'Mystery Pack',
      AppLanguage.french: 'Pack Mystère',
      AppLanguage.spanish: 'Pack Misterio',
    },
    'animals_nature': {
      AppLanguage.english: 'Animals & Nature',
      AppLanguage.french: 'Animaux & Nature',
      AppLanguage.spanish: 'Animales y Naturaleza',
    },
    'daily_life': {
      AppLanguage.english: 'Daily Life',
      AppLanguage.french: 'Vie quotidienne',
      AppLanguage.spanish: 'Vida Diaria',
    },
    'adults_only': {
      AppLanguage.english: 'Adults Only',
      AppLanguage.french: 'Adultes Uniquement',
      AppLanguage.spanish: 'Solo Adultos',
    },
    'anime': {AppLanguage.english: 'Anime', AppLanguage.french: 'Anime', AppLanguage.spanish: 'Anime'},
    'body_health': {
      AppLanguage.english: 'Body & Health',
      AppLanguage.french: 'Corps & Santé',
      AppLanguage.spanish: 'Cuerpo y Salud',
    },
    'brands': {AppLanguage.english: 'Brands', AppLanguage.french: 'Marques', AppLanguage.spanish: 'Marcas'},
    'characters': {
      AppLanguage.english: 'Characters',
      AppLanguage.french: 'Personnages',
      AppLanguage.spanish: 'Personajes',
    },
    // --- Subscription Screens ---
    'unlimited_access_title': {
      AppLanguage.english: 'Unlimited Access',
      AppLanguage.french: 'Accès illimité',
      AppLanguage.spanish: 'Acceso sin límites',
    },
    'feature_unlock_all': {
      AppLanguage.english: 'Unlock all packs',
      AppLanguage.french: 'Débloquez tous les packs',
      AppLanguage.spanish: 'Desbloquea todos los paquetes',
    },
    'feature_create_topics': {
      AppLanguage.english: 'Create your own topics',
      AppLanguage.french: 'Créez vos propres sujets',
      AppLanguage.spanish: 'Crea tus propios temas',
    },
    'feature_regular_updates': {
      AppLanguage.english: 'Regularly updated content',
      AppLanguage.french: 'Contenu mis à jour régulièrement',
      AppLanguage.spanish: 'Contenido actualizado con regularidad',
    },
    'feature_no_ads': {
      AppLanguage.english: 'No ads, ever!',
      AppLanguage.french: 'Sans publicité, jamais !',
      AppLanguage.spanish: '¡Sin anuncios, nunca!',
    },
    'annual': {AppLanguage.english: 'Annual', AppLanguage.french: 'Annuel', AppLanguage.spanish: 'Anual'},
    'annual_plan_desc': {
      AppLanguage.english: '12 months · 29.99 €',
      AppLanguage.french: '12 mois · 29,99 €',
      AppLanguage.spanish: '12 meses · 29,99 €',
    },
    'weekly_plan_label': {
      AppLanguage.english: 'Weekly',
      AppLanguage.french: 'Hebdomadaire',
      AppLanguage.spanish: 'Semanal',
    },
    'weekly_plan_desc': {
      AppLanguage.english: '1 week · 6.99 €',
      AppLanguage.french: '1 semaine · 6,99 €',
      AppLanguage.spanish: '1 semana · 6,99 €',
    },
    'annual_plan_desc_offer': {
      AppLanguage.english: '1 year · Only 9.99 € (Limited)',
      AppLanguage.french: '1 an · Seulement 9,99 € (Limité)',
      AppLanguage.spanish: '1 año · Solo 9,99 € (Limitado)',
    },
    'weekly_plan_desc_offer': {
      AppLanguage.english: '1 week · Only 0.99 € (Intro)',
      AppLanguage.french: '1 semaine · Seulement 0,99 € (Intro)',
      AppLanguage.spanish: '1 semana · Solo 0,99 € (Intro)',
    },
    'price_per_week_annual_offer': {
      AppLanguage.english: '0.19 €/week',
      AppLanguage.french: '0,19 €/semaine',
      AppLanguage.spanish: '0,19 €/semana',
    },
    'price_per_week_weekly_offer': {
      AppLanguage.english: '0.99 €/week',
      AppLanguage.french: '0,99 €/semaine',
      AppLanguage.spanish: '0,99 €/semana',
    },
    'save_97': {
      AppLanguage.english: 'Save 97%',
      AppLanguage.french: 'Économisez 97%',
      AppLanguage.spanish: 'Ahorra 97%',
    },
    'save_92': {
      AppLanguage.english: 'Save 92%',
      AppLanguage.french: 'Économisez 92%',
      AppLanguage.spanish: 'Ahorra 92%',
    },
    'save_86': {
      AppLanguage.english: 'Save 86%',
      AppLanguage.french: 'Économisez 86%',
      AppLanguage.spanish: 'Ahorra 86%',
    },
    'price_per_week_annual': {
      AppLanguage.english: '0.58 €/week',
      AppLanguage.french: '0,58 €/semaine',
      AppLanguage.spanish: '0,58 €/semana',
    },
    'price_per_week_weekly': {
      AppLanguage.english: '6.99 €/week',
      AppLanguage.french: '6,99 €/semaine',
      AppLanguage.spanish: '6,99 €/semana',
    },
    'best_party_game': {
      AppLanguage.english: '#1 Party Game',
      AppLanguage.french: '#1 Jeu de fête',
      AppLanguage.spanish: '#1 Juego de fiesta',
    },
    'fun_for_any_group': {
      AppLanguage.english: 'Fun for any group',
      AppLanguage.french: 'Amusant pour tout groupe',
      AppLanguage.spanish: 'Divertido para cualquier grupo',
    },
    'welcome_offer_title': {
      AppLanguage.english: 'Welcome Offer',
      AppLanguage.french: 'Offre de Bienvenue',
      AppLanguage.spanish: 'Oferta de Bienvenida',
    },
    'only_price': {
      AppLanguage.english: 'Only 0.99 €',
      AppLanguage.french: 'Seulement 0,99 €',
      AppLanguage.spanish: 'Solo 0,99 €',
    },
    'only_price_annual': {
      AppLanguage.english: 'Only 9.99 €',
      AppLanguage.french: 'Seulement 9,99 €',
      AppLanguage.spanish: 'Solo 9,99 €',
    },
    'welcome_offer_subtitle': {
      AppLanguage.english: 'First week at a special price, then 6.99 €/week. Cancel anytime.',
      AppLanguage.french: 'Première semaine à prix spécial, puis 6,99 €/semaine. Annulez à tout moment.',
      AppLanguage.spanish: 'Primera semana a precio especial, luego 6,99 €/semana. Cancela cuando quieras.',
    },
    'welcome_offer_subtitle_annual': {
      AppLanguage.english: 'First year at a special price, then 29.99 €/year. Cancel anytime.',
      AppLanguage.french: 'Première année à prix spécial, puis 29,99 €/an. Annulez à tout moment.',
      AppLanguage.spanish: 'Primer año a precio especial, luego 29,99 €/año. Cancela cuando quieras.',
    },
    'save_67': {
      AppLanguage.english: 'Save 67%',
      AppLanguage.french: 'Économisez 67%',
      AppLanguage.spanish: 'Ahorra 67%',
    },
    'unique_offer': {
      AppLanguage.english: 'Unique offer — take advantage of it!',
      AppLanguage.french: 'Offre unique — profitez-en !',
      AppLanguage.spanish: 'Oferta única — ¡aprovéchala!',
    },
    'activate_offer': {
      AppLanguage.english: 'Activate Offer',
      AppLanguage.french: 'Activer l\'offre',
      AppLanguage.spanish: 'Activar Oferta',
    },
    'price_per_year': {
      AppLanguage.english: '29.99 €/year',
      AppLanguage.french: '29,99 €/an',
      AppLanguage.spanish: '29,99 €/año',
    },
    'difficulty_low': {AppLanguage.english: 'Low', AppLanguage.french: 'Faible', AppLanguage.spanish: 'Bajo'},
    'difficulty_hard': {AppLanguage.english: 'Hard', AppLanguage.french: 'Difficile', AppLanguage.spanish: 'Difícil'},
    'difficulty_very_hard': {
      AppLanguage.english: 'Very Hard',
      AppLanguage.french: 'Très difficile',
      AppLanguage.spanish: 'Muy difícil',
    },
    'punishment_shave': {
      AppLanguage.english: 'Shave eyebrows',
      AppLanguage.french: 'Raser les sourcils',
      AppLanguage.spanish: 'Afeitarse las cejas',
    },
    'select_difficulty': {
      AppLanguage.english: 'Select difficulty',
      AppLanguage.french: 'Sélectionner la difficulté',
      AppLanguage.spanish: 'Seleccionar dificultad',
    },
  };

  String get(String key) {
    final values = _localizedValues[key];
    if (values == null) return key;
    return values[language] ?? values[AppLanguage.english] ?? key;
  }
}
