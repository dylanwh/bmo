/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is the Cross Platform JavaScript Utility Library.
 *
 * The Initial Developer of the Original Code is
 * Everything Solved.
 * Portions created by the Initial Developer are Copyright (C) 2007
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Max Kanat-Alexander <mkanat@bugzilla.org>
 *   Christopher A. Aillon <christopher@aillon.com>
 *
 * ***** END LICENSE BLOCK ***** */

/**
 * Locate where an element is on the page, x-wise.
 *
 * @param  obj Element of which location to return.
 * @return     Current position of the element relative to the left of the
 *             page window. Measured in pixels.
 */
function bz_findPosX(obj)
{
    var curleft = 0;

    if (obj.offsetParent) {
        while (obj) {
            if (getComputedStyle(obj).position != 'relative')
                curleft += obj.offsetLeft;
            obj = obj.offsetParent;
        }
    }
    else if (obj.x) {
        curleft += obj.x;
    }

    return curleft;
}

/**
 * Locate where an element is on the page, y-wise.
 *
 * @param  obj Element of which location to return.
 * @return     Current position of the element relative to the top of the
 *             page window. Measured in pixels.
 */
function bz_findPosY(obj)
{
    var curtop = 0;

    if (obj.offsetParent) {
        while (obj) {
            if (getComputedStyle(obj).position != 'relative')
                curtop += obj.offsetTop;
            obj = obj.offsetParent;
        }
    }
    else if (obj.y) {
        curtop += obj.y;
    }

    return curtop;
}

/**
 * Get the full height of an element, even if it's larger than the browser
 * window.
 *
 * @param  fromObj Element of which height to return.
 * @return         Current height of the element. Measured in pixels.
 */
function bz_getFullHeight(fromObj)
{
    var scrollY;

    // All but Mac IE
    if (fromObj.scrollHeight > fromObj.offsetHeight) {
        scrollY = fromObj.scrollHeight;
    // Mac IE
    }  else {
        scrollY = fromObj.offsetHeight;
    }

    return scrollY;
}

/**
 * Get the full width of an element, even if it's larger than the browser
 * window.
 *
 * @param  fromObj Element of which width to return.
 * @return         Current width of the element. Measured in pixels.
 */
function bz_getFullWidth(fromObj)
{
    var scrollX;

    // All but Mac IE
    if (fromObj.scrollWidth > fromObj.offsetWidth) {
        scrollX = fromObj.scrollWidth;
    // Mac IE
    }  else {
        scrollX = fromObj.offsetWidth;
    }

    return scrollX;
}

/**
 * Causes a block to appear directly underneath another block,
 * overlaying anything below it.
 *
 * @param item   The block that you want to move.
 * @param parent The block that it goes on top of.
 * @return nothing
 */
function bz_overlayBelow(item, parent) {
    var elemY = bz_findPosY(parent);
    var elemX = bz_findPosX(parent);
    var elemH = parent.offsetHeight;

    item.style.position = 'absolute';
    item.style.left = elemX + "px";
    item.style.top = elemY + elemH + 1 + "px";
    item.style.zIndex = 999;
}

/**
 * Checks if a specified value is in the specified array.
 *
 * @param  aArray Array to search for the value.
 * @param  aValue Value to search from the array.
 * @return        Boolean; true if value is found in the array and false if not.
 */
function bz_isValueInArray(aArray, aValue)
{
  for (var run = 0, len = aArray.length ; run < len; run++) {
    if (aArray[run] == aValue) {
      return true;
    }
  }

  return false;
}

/**
 * Checks if a specified value is in the specified array by performing a
 * case-insensitive comparison.
 *
 * @param  aArray Array to search for the value.
 * @param  aValue Value to search from the array.
 * @return        Boolean; true if value is found in the array and false if not.
 */
function bz_isValueInArrayIgnoreCase(aArray, aValue)
{
  var re = new RegExp(aValue.replace(/([^A-Za-z0-9])/g, "\\$1"), 'i');
  for (var run = 0, len = aArray.length ; run < len; run++) {
    if (aArray[run].match(re)) {
      return true;
    }
  }

  return false;
}

/**
 * Create wanted options in a select form control.
 *
 * @param  aSelect        Select form control to manipulate.
 * @param  aValue         Value attribute of the new option element.
 * @param  aTextValue     Value of a text node appended to the new option
 *                        element.
 * @return                Created option element.
 */
function bz_createOptionInSelect(aSelect, aTextValue, aValue) {
  var myOption = new Option(aTextValue, aValue);
  aSelect.options[aSelect.length] = myOption;
  return myOption;
}

/**
 * Clears all options from a select form control.
 *
 * @param  aSelect    Select form control of which options to clear.
 */
function bz_clearOptions(aSelect) {

  var length = aSelect.options.length;

  for (var i = 0; i < length; i++) {
    aSelect.removeChild(aSelect.options[0]);
  }
}

/**
 * Takes an array and moves all the values to an select.
 *
 * @param aSelect         Select form control to populate. Will be cleared
 *                        before array values are created in it.
 * @param aArray          Array with values to populate select with.
 */
function bz_populateSelectFromArray(aSelect, aArray) {
  // Clear the field
  bz_clearOptions(aSelect);

  for (var i = 0; i < aArray.length; i++) {
    var item = aArray[i];
    bz_createOptionInSelect(aSelect, item[1], item[0]);
  }
}

/**
 * Returns all Option elements that are selected in a <select>,
 * as an array. Returns an empty array if nothing is selected.
 *
 * @param aSelect The select you want the selected values of.
 */
function bz_selectedOptions(aSelect) {
    // HTML 5
    if (aSelect.selectedOptions) {
        return aSelect.selectedOptions;
    }

    var start_at = aSelect.selectedIndex;
    if (start_at == -1) return [];
    var first_selected =  aSelect.options[start_at];
    if (!aSelect.multiple) return first_selected;
    // selectedIndex is specified as being the "first selected item",
    // so we can start from there.
    var selected = [first_selected];
    var options_length = aSelect.options.length;
    // We start after first_selected
    for (var i = start_at + 1; i < options_length; i++) {
        var this_option = aSelect.options[i];
        if (this_option.selected) selected.push(this_option);
    }
    return selected;
}

/**
 * Returns all Option elements that have the "selected" attribute, as an array.
 * Returns an empty array if nothing is selected.
 *
 * @param aSelect The select you want the pre-selected values of.
 */
function bz_preselectedOptions(aSelect) {
    var options = aSelect.options;
    var selected = new Array();
    for (var i = 0, l = options.length; i < l; i++) {
        var attributes = options[i].attributes;
        for (var j = 0, m = attributes.length; j < m; j++) {
            if (attributes[j].name == 'selected') {
                if (!aSelect.multiple) return options[i];
                selected.push(options[i]);
            }
        }
    }
    return selected;
}

/**
 * Tells you whether or not a particular value is selected in a select,
 * whether it's a multi-select or a single-select. The check is
 * case-sensitive.
 *
 * @param aSelect        The select you're checking.
 * @param aValue         The value that you want to know about.
 */
function bz_valueSelected(aSelect, aValue) {
    var options = aSelect.options;
    for (var i = 0; i < options.length; i++) {
        if (options[i].selected && options[i].value == aValue) {
            return true;
        }
    }
    return false;
}

/**
 * Tells you where (what index) in a <select> a particular option is.
 * Returns -1 if the value is not in the <select>
 *
 * @param aSelect       The select you're checking.
 * @param aValue        The value you want to know the index of.
 */
function bz_optionIndex(aSelect, aValue) {
    for (var i = 0; i < aSelect.options.length; i++) {
        if (aSelect.options[i].value == aValue) {
            return i;
        }
    }
    return -1;
}

/**
 * Used to fire an event programmatically.
 *
 * @param anElement      The element you want to fire the event of.
 * @param anEvent        The name of the event you want to fire,
 *                       without the word "on" in front of it.
 */
function bz_fireEvent(anElement, anEvent) {
    if (document.createEvent) {
        // DOM-compliant browser
        var evt = document.createEvent("HTMLEvents");
        evt.initEvent(anEvent, true, true);
        return !anElement.dispatchEvent(evt);
    } else {
        // IE
        var evt = document.createEventObject();
        return anElement.fireEvent('on' + anEvent, evt);
    }
}

/**
 * Adds a CSS class to an element if it doesn't have it. Removes the
 * CSS class from the element if the element does have the class.
 *
 * Requires YUI's Dom library.
 *
 * @param anElement  The element to toggle the class on
 * @param aClass     The name of the CSS class to toggle.
 */
function bz_toggleClass(anElement, aClass) {
    if (YAHOO.util.Dom.hasClass(anElement, aClass)) {
        YAHOO.util.Dom.removeClass(anElement, aClass);
    }
    else {
        YAHOO.util.Dom.addClass(anElement, aClass);
    }
}

/* Retruns a string representation of a duration.
 *
 * @param ss   Duration in seconds
 * or
 * @param date Date object
 */
function timeAgo(param) {
    var ss = param.constructor === Date ? Math.round((new Date() - param) / 1000) : param;
    var mm = Math.round(ss / 60),
        hh = Math.round(mm / 60),
        dd = Math.round(hh / 24),
        mo = Math.round(dd / 30),
        yy = Math.round(mo / 12);
    if (ss < 10) return 'Just now';
    if (ss < 45) return ss + ' seconds ago';
    if (ss < 90) return '1 minute ago';
    if (mm < 45) return mm + ' minutes ago';
    if (mm < 90) return 'Last hour';
    if (hh < 24) return hh + ' hours ago';
    if (hh < 36) return 'Yesterday';
    if (dd < 30) return dd + ' days ago';
    if (dd < 45) return 'Last month';
    if (mo < 12) return mo + ' months ago';
    if (mo < 18) return 'Last year';
    return yy + ' years ago';
}
