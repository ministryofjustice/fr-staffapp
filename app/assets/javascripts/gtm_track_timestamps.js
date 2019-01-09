'use strict';

window.moj.Modules.GtmTrackTimestamps = {
  hompage: function() {
    moj.Modules.Cookies.set('homepage_visited_timestamp', Date.now());
  },

  getTimestamps: function() {
    var homepage_timestamp = parseInt(moj.Modules.Cookies.get('homepage_visited_timestamp'), 10);
    var current_page_timestamp = Date.now();
    var transition_time_in_ms = current_page_timestamp - homepage_timestamp;

    return {
      'homepage': homepage_timestamp,
      'currentPage': current_page_timestamp,
      'transitionTimeInMs': transition_time_in_ms
    }
  },

  processedApplication: function() {
    var timestamps = this.getTimestamps()

    dataLayer.push({
      'event': 'Processed_Application_Timestamp',
      'hompageTimestamp': timestamps.homepage,
      'processedApplicationTimestamp': timestamps.currentPage,
      'transitionTimeInMs': timestamps.transitionTimeInMs
    });
  },

  deletedApplication: function() {
    var timestamps = this.getTimestamps()

    dataLayer.push({
      'event': 'Deleted_Application_Timestamp',
      'hompageTimestamp': timestamps.homepage,
      'deletedApplicationTimestamp': timestamps.currentPage,
      'transitionTimeInMs': timestamps.transitionTimeInMs
    });
  },

  evidence: function() {
    var timestamps = this.getTimestamps()

    dataLayer.push({
      'event': 'Evidence_Timestamp',
      'hompageTimestamp': timestamps.homepage,
      'evidenceTimestamp': timestamps.currentPage,
      'transitionTimeInMs': timestamps.transitionTimeInMs
    });
  },

  partPayment: function() {
    var timestamps = this.getTimestamps()

    dataLayer.push({
      'event': 'Part_Payment_Timestamp',
      'hompageTimestamp': timestamps.homepage,
      'partPaymentTimestamp': timestamps.currentPage,
      'transitionTimeInMs': timestamps.transitionTimeInMs
    });
  }

};