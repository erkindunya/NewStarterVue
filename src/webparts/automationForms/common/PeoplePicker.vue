<template>
<div>
    <vue-select label="DisplayText"
                :class="mainClass"
                :filterable="false"
                :options="people"
                v-bind:value="value"
                v-on:input="$emit('input', $event)"
                @search="searchPeople">
        <template slot="no-options">
            <div @mousedown.stop="">
                Begin typing to search..
            </div>
        </template>
        <template slot="option" slot-scope="option">
            {{ option.DisplayText }} ({{ option.EntityData.Email || "No Email" }})
        </template>
    </vue-select>
</div>
</template>
<style scoped></style>
<script lang="ts">
import Vue from 'vue';
import { sp, PeoplePickerEntity } from '@pnp/sp';
import { VueSelect } from 'vue-select';
import { debounce } from 'lodash';
import { setup } from '@pnp/sp/src/config/splibconfig';

export default Vue.extend({
    name: 'people-picker',
    props: ['value', 'class'],
    data: () => ({
        people: <PeoplePickerEntity[]>[]
    }),
    computed: {
        selectedValue() {
            return this.value || "";
        },
        mainClass() {
            return this.class || {};
        }
    },
    methods: {
        searchPeople: debounce(async function (search, loading) {
            loading(true);
            const standardSearch = sp.profiles.clientPeoplePickerSearchUser({
                'AllowEmailAddresses':true,
                'AllowMultipleEntities':false,
                'AllUrlZones':false,
                'MaximumEntitySuggestions':20,
                'PrincipalSource':15,
                'PrincipalType': 1,
                'QueryString': search
            });
            
            if(search.indexOf(' ') > -1) {
                const newSearch = search.split(' ').reverse().join(', ');
                const rearrangedSearch = sp.profiles.clientPeoplePickerSearchUser({
                    'AllowEmailAddresses':true,
                    'AllowMultipleEntities':false,
                    'AllUrlZones':false,
                    'MaximumEntitySuggestions':20,
                    'PrincipalSource':15,
                    'PrincipalType': 1,
                    'QueryString': newSearch
                });
                const results = await Promise.all([standardSearch, rearrangedSearch]);
                this.people = results[0].concat(results[1]);
            } else {
                this.people = await standardSearch;
            }
            loading(false);
        }, 800)
    },
    components: {
        VueSelect
    }
});
</script>