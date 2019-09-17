/**
 * @namespace WORKAREA.sortSegments
 */
WORKAREA.registerModule('sortSegments', (function () {
    'use strict';

    var findSegmentPositions = function (event) {
            var result = {},
                $segments = $('[data-sort-segment-id]', event.target);

            $segments.each(function (index, segment) {
                var id = $(segment).data('sortSegmentId');

                if (id) {
                    result['positions[' + id + ']'] = index;
                }
            });

            return result;
        },

        saveSort = function (event) {
            $.post(
                WORKAREA.routes.admin.moveSegmentsPath(),
                findSegmentPositions(event)
            );
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.sortSegments
         */
        init = function ($scope) {
            $('[data-sort-segments]', $scope).sortable({ stop: saveSort });
        };

    return {
        init: init
    };
}()));
