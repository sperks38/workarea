/**
 * @namespace WORKAREA.activeBySegmentTooltips
 */
WORKAREA.registerModule('activeBySegmentTooltips', (function () {
    'use strict';

    var initTooltip = function (index, trigger) {
            var $form = $(trigger).closest('form');

            $(trigger).tooltipster(
                _.assign({}, WORKAREA.config.tooltipster, {
                    interactive: true,
                    content: $($(trigger).attr('href')),
                    functionAfter: _.partial(addHiddenInputs, $form)
                })
            );
        },

        addHiddenInputs = function ($form, instance) {
            $form.find(':data(active-by-segment-input)').remove();

            instance.content().find('select').each(function (i, select) {
                var $select = $(select),
                    $input = $('<input/>')
                    .attr({ type: 'hidden', name: $select.attr('name'), value: $select.val() })
                    .data('active-by-segment-input', true);

                $form.append($input);
            });
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.activeBySegmentTooltips
         */
        init = function ($scope) {
            $('[data-active-by-segment-tooltip]', $scope).each(initTooltip);
        };

    return {
        init: init
    };
}()));
